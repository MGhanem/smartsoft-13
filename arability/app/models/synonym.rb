class Synonym < ActiveRecord::Base
  belongs_to :keywords
  attr_accessible :approved, :name
  has_many :votes
end
