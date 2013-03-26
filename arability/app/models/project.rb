class Project < ActiveRecord::Base
  belongs_to :developer
  has_and_belongs_to_many :categories
  has_many :keywords
  attr_accessible :description, :formal, :maxAge, :minAge, :name
  validates :name, :presence => true,:length => { :maximum => 30 }
  validates :minAge, :presence => true, :inclusion => { :in => 9..99 },:numericality => { :only_integer => true }
  validates :maxAge, :presence => true, :inclusion => { :in => 10..100 },:numericality => { :only_integer => true,:greater_than_or_equal_to => :age}
  validates :formal, :presence => true
end
