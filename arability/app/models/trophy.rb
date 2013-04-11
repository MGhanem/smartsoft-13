#encoding: UTF-8
class Trophy < ActiveRecord::Base
  include Paperclip::Glue

  has_and_belongs_to_many :gamers
  attr_accessible :name, :level, :score, :image
  has_attached_file :image

  validates_format_of :name, 
                      :with => /^([\u0621-\u0652 ])+$/, 
                      :message => "اسم الانجاز يجب ان يكون بالعربية"

  validates_length_of :name, 
                      :maximum => 15,
                      :message => "اسم الانجاز لا يمكن ان يزيد عن 10 حروف"

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

  class << self

    # author:
    #     Karim ElNaggar
    # description:
    #     a function adds a new trophy to the database
    # params
    #     name, level, score, image
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

  end
end
