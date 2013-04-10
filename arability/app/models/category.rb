class Category < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :projects

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :name, :with => /^([\u0621-\u0652 ]+|[a-zA-z ]+)$/

  # adds a new category to the database or returns the category already in the database
  # author:
  #   Mohamed Ashraf
  # params:
  #   name: the actual category string
  # returns:
  #   success: the first return is true and the second is the saved category
  #   failure: the first return is false and the second is the unsaved category
  class << self
    include StringHelper
    def add_category_to_database_if_not_exists(name)
      name.strip!
      name.downcase! if is_english_string(name)
      category = Category.where(:name => name).first_or_create
      if category.save
        return true, category
      else
        return false, category
      end
    end
  end
end
