class Keyword < ActiveRecord::Base
  has_many :synonyms
  attr_accessible :approved, :is_english, :name
end
