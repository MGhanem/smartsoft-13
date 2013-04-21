#encoding: UTF-8
class Category < ActiveRecord::Base
  attr_accessible :english_name, :arabic_name
  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :projects

  validates_uniqueness_of :english_name
  validates_presence_of :english_name
  validates_format_of :english_name, :with => /^([a-zA-Z ]+)$/

  validates_uniqueness_of :arabic_name
  validates_presence_of :arabic_name
  validates_format_of :arabic_name, :with => /^([\u0621-\u0652 ]+)$/

  class << self
    include StringHelper
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   adds a new category to the database or returns the category already in the database
  # params:
  #   name: the actual category string
  # success:
  #   the first return is true and the second is the saved category
  # failure:
  #   the first return is false and the second is the unsaved category
  def self.add_category_to_database_if_not_exists(name)
    name.strip!
    name.downcase! if is_english_string(name)
    name = name.split(" ").join(" ")
    category = Category.where(:name => name).first_or_create
    return category.save ? [true, category] : [false, category]
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
