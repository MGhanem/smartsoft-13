class Synonym < ActiveRecord::Base
  attr_accessible :name

  has_many :votes
  has_many :users, :through => :votes

  belongs_to :keyword

end
