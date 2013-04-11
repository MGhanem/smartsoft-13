#encoding: UTF-8
class Prize < ActiveRecord::Base
  include Paperclip::Glue

  has_and_belongs_to_many :gamers
  attr_accessible :name, :level, :score, :image
  has_attached_file :image

  validates_format_of :name, 
                      :with => /^([\u0621-\u0652 ])+$/, 
                      :message => "اسم الجائزة يجب ان يكون بالعربية"

  validates_length_of :name, 
                      :maximum => 15,
                      :message => "اسم الجائزة لا يمكن ان يزيد عن 10 حروف"

  validates_presence_of :name, 
                        message: "اسم الجائزة لا يمكن ان يكون فارغ"

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
                            less_than_or_equal_to: 5, 
                            message: "المستوى يجب ان يكون بين 0 و 5"

  validates_numericality_of :score, 
                            only_integer: true, 
                            greater_than: 0, 
                            less_than_or_equal_to: 10000,
                            message: "مجموع النقاط يجب ان يكون بين 0 و  10000"

  validates_attachment_content_type :image, 
                                    :content_type => /^image\/(png|gif|jpeg)/,
                                    message: "الصورة يجب ان تكون بصيغة png, gif او jpeg"

  class << self
    
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
    def add_prize_to_database(name, level, score, image)
      new_prize = Prize.new(name: name, level: level, score: score, image: image)
      if new_prize.save
        return true, new_prize
      else
        return false, new_prize
      end
    end

    # author:
    #     Karim ElNaggar
    # description:
    #     a function edits a prize
    # params
    #     name: the name of the prize
    #     level: the level of the prize
    #     score: the score of the prize
    #     image: the image of the prize
    # success: 
    #     returns true and the  prize if it is successfully updated
    # failure: 
    #     returns false and the prize if it is not successfully updated
    def edit_prize(name, level, score, image)
      cur_prize = Prize.find_by_name(name)
      if cur_prize == nil
        return false, cur_prize
      else
        if level
          cur_prize.level = level
        end
        if score
          cur_prize.score = score
        end
        if image
          cur_prize.image = image
        end
        if cur_prize.save
          return true, cur_prize
        else
          return false, cur_prize
        end
      end
    end

  end
end
