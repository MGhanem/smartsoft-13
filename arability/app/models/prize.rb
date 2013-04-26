#encoding: UTF-8
class Prize < ActiveRecord::Base
  include Paperclip::Glue
  
  has_and_belongs_to_many :gamers
  attr_accessible :name, :level, :score, :image, :image_file_name, :image_content_type, :image_file_size, :image_updated_at
  has_attached_file :image

  validates_presence_of :name, 
                        message: "اسم الجائزة لا يمكن ان يكون فارغ"

  validates_format_of :name, 
                      :with => /^([\u0621-\u0652 ])+$/, 
                      :message => "اسم الجائزة يجب ان يكون بالعربية"

  validates_length_of :name,
                      :minimum => 6, 
                      :maximum => 24,
                      :message => "اسم الجائزة يجب ان يكون بين 6 و 24 حرف"

  validates_presence_of :level, 
                        message: "المستوى لا يمكن ان يكون فارغ"

  validates_presence_of :score, 
                        message: "مجموع النقاط لا يمكن ان يكون فارغ"

  validates_presence_of :image, 
                        message: "الصورة لا يمكن ان تكون فارغة"

  validates_uniqueness_of :name, 
                          message: "اسم الجائزة مستعمل"

  validates_numericality_of :level, 
                            only_integer: true, 
                            greater_than: 0, 
                            less_than_or_equal_to: 100, 
                            message: "المستوى يجب ان يكون بين 1 و 100"

  validates_numericality_of :score, 
                            only_integer: true, 
                            greater_than: 0, 
                            less_than_or_equal_to: 1000000,
                            message: "مجموع النقاط يجب ان يكون بين 1 و  1000000"

  validates_attachment_content_type :image, 
                                    :content_type => /^image\/(png|gif|jpeg)/,
                                    message: "الصورة يجب ان تكون بصيغة png, gif او jpeg"

  validates_attachment_size :image, 
                            :in => 0.megabytes..1.megabytes,
                            message: "يجب ان يكون حجم الصورة اقل من 1MB"

  # Description:
  #   returns a list of prizes that the gamer got awarded 
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
  #     an array of the prizes that the gamer won
  #   failure:
  #     no failure
  def self.get_new_prizes_for_gamer(gamer_id, score, level)
    prizes_for_score = []
    gamer = Gamer.find(gamer_id)
    prizes_gamer = gamer.prizes
    prizes_of_level = Prize.where(level: level)
    new_prizes = prizes_of_level - prizes_gamer
    new_prizes.map { |np| prizes_for_score << np if np.score <= score }
    prizes_for_score.map { |p| gamer.prizes << p }
    gamer.save
    return prizes_for_score
  end

  # author:
  #   Adam Ghanem
  # description:
  #   checks if the gamer with the given id can get any
  #   prizes for the given score or level
  # params:
  #   gamer_id: id of a gamer instance
  #   level: the level of the prize
  #   score: the score of the prize
  # success:
  #   returns true and there are any prizes with the given params
  # failure:
  #   none
  def self.new_prizes_for_gamer?(gamer_id, score, level)
    prizes_for_score = []
    gamer = Gamer.find(gamer_id)
    prizes_gamer = gamer.prizes
    prizes_of_level = Prize.where(:level => level)
    new_prizes = prizes_of_level - prizes_gamer
    new_prizes.map { |np| prizes_for_score << np if np.score <= score }
    return prizes_for_score.size > 0
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     a function adds a new prize to the database
  # params
  #     name: the name of the prize
  #     level: the level of the prize
  #     score: the score of the prize
  #     image: the image of the prize
  # success: 
  #     returns true and the new prize if it is added to the database
  # failure: 
  #     returns false and the prize if it is not added to the database
  def self.add_prize_to_database(name, level, score, image)
    new_prize = Prize.new(name: name, level: level, score: score, image: image)
    if new_prize.save
      return true, new_prize
    else
      return false, new_prize
    end
  end

end
