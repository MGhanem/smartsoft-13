#encoding: UTF-8
class Trophy < ActiveRecord::Base
  include Paperclip::Glue

  validates :name, :presence => true, :length => { :in => 6..24 },
    :uniqueness => true
  validates_format_of :name, :with =>  /^([\u0621-\u0652 ])+$/
  validates :level, :presence => true, :numericality => {
    :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100 }
  validates :score, :presence => true, :numericality => {
    :greater_than_or_equal_to => 1, :less_than_or_equal_to => 1000000 }
  validates :image, :presence => true
  validates_attachment_size :image, :in => 0.megabytes..0.5.megabytes
  
  has_and_belongs_to_many :gamers
  attr_accessible :name, :level, :score, :image, :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  has_attached_file :image

  validates_format_of :name, 
                      :with => /^([\u0621-\u0652 ])+$/, 
                      :message => "اسم الانجاز يجب ان يكون بالعربية"

  validates_length_of :name, 
                      :maximum => 20,
                      :message => "اسم الانجاز لا يمكن ان يزيد عن 20 حروف"

  validates_presence_of :name, 
                        message: "اسم الانجاز لا يمكن ان يكون فارغ"

  validates_presence_of :level, 
                        message: "المستوى لا يمكن ان يكون فارغ"

  validates_presence_of :score, 
                        message: "مجموع النقاط لا يمكن ان يكون فارغ"

  validates_presence_of :image, 
                        message: "الصورة لا يمكن ان تكون فارغة"

  validates_uniqueness_of :name, 
                          message: "اسم الانجاز مستعمل"

  validates_numericality_of :level, 
                            only_integer: true, 
                            greater_than: 0, 
                            less_than_or_equal_to: 5, 
                            message: "المستوى يجب ان يكون بين 0 و 5"

  validates_numericality_of :score, 
                            only_integer: true, 
                            greater_than: 0,
                            less_than_or_equal_to: 10000,
                            message: "مجموع النقاط يجب ان يكون بين 0 و 10000"

  validates_attachment_content_type :image, 
                                    :content_type => /^image\/(png|gif|jpeg)/,
                                    message: "الصورة يجب ان تكون بصيغة png, gif او jpeg"

  attr_accessible :name, :level, :score, :image

  has_attached_file :image

    # Description:
    #   returns a list of trophies that the gamer got awarded 
    #   and awards it to the current_gamer
    # Author:
    #   Adam Ghanem
    # @params:
    #   gamer_id: the gamer id of the current signed in gamer
    #   score: the score that was just scored in the game
    #   level: the level that the gamer was on before the method was
    #          called
    # returns:
    #   success:
    #     an array of the trophies that the gamer won
    #   failure:
    #     no failure
    def self.get_new_trophies_for_gamer(gamer_id, score, level)
      trophies_for_score = []
      gamer = Gamer.find(gamer_id)
      trophies_gamer = gamer.trophies
      trophies_of_level = Trophy.where(:level => level)
      new_trophies = trophies_of_level - trophies_gamer
      new_trophies.map { |nt| trophies_for_score << nt if nt.score <= score }
      trophies_for_score.map { |t| gamer.trophies << t }
      gamer.save
      return trophies_for_score
    end

    # author:
    #     Karim ElNaggar
    # description:
    #     a function adds a new trophy to the database
    # params
    #     name: the name of the trophy
    #     level: the level of the trophy
    #     score: the score of the trophy 
    #     image: the image of the trophy6
    # success: 
    #     returns true and the new trophy if it is added to the database
    # failure: 
    #     returns false and the trophy if it is not added to the database
    def self.add_trophy_to_database(name, level, score, image)
      new_trophy = Trophy.new(name: name, level: level, score: score, image: image)
      if new_trophy.save
        return true, new_trophy
      else
        return false, new_trophy
      end
    end

end
