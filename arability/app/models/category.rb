class Category < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :projects
end