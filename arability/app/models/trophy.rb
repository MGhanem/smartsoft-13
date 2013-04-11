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
  attr_accessible :name, :level, :score, :image
  has_attached_file :image

  validates_format_of :name, 
                      :with => /^([\u0621-\u0652 ])+$/, 
                      :message => "اسم المدالية يجب ان يكون بالعربية"

  validates_length_of :name, 
                      :maximum => 10,
                      :message => "اسم المدالية لا يمكن ان يزيد عن 10 حروف"

  validates_presence_of :name, 
                        message: "اسم المدالية لا يمكن ان يكون فارغ"

  validates_presence_of :level, 
                        message: "المستوى لا يمكن ان يكون فارغ"

  validates_presence_of :score, 
                        message: "مجموع النقاط لا يمكن ان يكون فارغ"

  validates_presence_of :image, 
                        message: "الصورة لا يمكن ان تكون فارغة"

  validates_uniqueness_of :name, 
                          message: "اسم المدالية مستعمل"

  validates_numericality_of :level, 
                            only_integer: true, 
                            greater_than: 0, 
                            less_than_or_equal_to: 10, 
                            message: "المستوى يجب ان يكون بين 0 و 10"

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

  class << self

    def get_new_trophies_for_gamer(gamer_id, score, level)
      trophies_all = Trophy.where(:score => score, :level => level)
      trophies_gamer = Gamer.find(gamer_id).trophies
      return trophies_all - trophies_gamer
    end

    # author:
    #     Karim ElNaggar
    # description:
    #     a function adds a new trophy to the database
    # params
    #     name, level, score, image
    #     name, score, rank, image
    # success: 
    #     returns true and the new trophy if it is added to the database
    # failure: 
    #     returns false and the trophy if it is not added to the database
    def add_trophy_to_database(name, level, score, image)
      new_trophy = Trophy.new(name: name, level: level, score: score, image: image)
      if new_trophy.save
        return true, new_trophy
      else
        return false, new_trophy
      end
    end

    def edit_trophy(name, level, score, image)
      cur_trophy = Trophy.find_by_name(name)
      if cur_trophy == nil
        return false, nil
      else
        if level
          cur_trophy.level = level
        end
        if score
          cur_trophy.score = score
        end
        if image
          cur_trophy.image = image
        end
        if cur_trophy.save
          return true, cur_trophy
        else
          return false, cur_trophy
        end
      end
    end
   
    def get_new_trophies_for_gamer(gamer_id, score, level)
      trophies_for_score = []
      trophies_gamer = Gamer.find(gamer_id).trophies
      trophies_of_level = Trophy.where(:level => level)
      new_trophies = trophies_of_level - trophies_gamer
      new_trophies.map { |nt| trophies_for_score << nt if nt.score <= score }
      return trophies_for_score
    end


  # has_attached_file :photo

  end
end
