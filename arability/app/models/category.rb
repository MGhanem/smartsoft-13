#encoding: UTF-8
class Category < ActiveRecord::Base
  attr_accessible :english_name, :arabic_name
  has_and_belongs_to_many :keywords
  has_many :projects

  validates_uniqueness_of :english_name,
    message: "هذا الإسم بالإنجليزية للفئة يوجد بلفعل"
  validates_presence_of :english_name, message: "لا يمكن تسجيل إسم فئة إنجليزي فارغ"
  validates_format_of :english_name, with: /^([a-zA-Z ]+)$/,
    message: "هذا الإسم الإنجليزي للفئة ليس بالإنجليزية"
  validates_uniqueness_of :arabic_name,
    message: "هذا الإسم بالعربية للفئة يوجد بلفعل"
  validates_presence_of :arabic_name,
    message: "لا يمكن تسجيل إسم فئة عربي فارغ"
  validates_format_of :arabic_name, with: /^([\u0621-\u0652 ]+)$/,
    message: "هذا الإسم العربي للفئة ليس بالعربية" 

  class << self
    include StringHelper
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   adds a new category to the database or returns the category already in the database
  # params:
  #   english_name: the english name of the category
  #   arabic_name: the arabic name of the category
  # success:
  #   the first return is true and the second is the saved category
  # failure:
  #   the first return is false and the second is the unsaved category
  def self.add_category_to_database_if_not_exists(english_name, arabic_name)
    english_name.strip!
    arabic_name.strip!

    english_name.downcase!

    english_name = english_name.split(" ").join(" ")
    arabic_name = arabic_name.split(" ").join(" ")

    category = Category.where(english_name: english_name,
      arabic_name: arabic_name).first_or_create

    category.save ? [true, category] : [false, category]
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   Get the name of the category according to current locale
  # params:
  #   --
  # success:
  #   returns english_name if the locale is english otherwise arabic_name
  # failure:
  #   --
  def get_name_by_locale
    I18n.locale == :en ? english_name : arabic_name
  end

end
