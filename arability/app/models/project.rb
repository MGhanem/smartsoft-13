class Project < ActiveRecord::Base
  belongs_to :developer
  has_and_belongs_to_many :categories
  has_many :keywords
  attr_accessible :description, :formal, :maxAge, :minAge, :name, :categories
  validates :name, :presence => true,:length => { :maximum => 30 }
  validates :minAge, :presence => true, :inclusion => { :in => 9..99 },:numericality => { :only_integer => true }
  validates :maxAge, :presence => true, :inclusion => { :in => 10..100 },:numericality => { :only_integer => true,:greater_than_or_equal_to => :minAge}
  validates :formal, :presence => true

  def self.createproject(params)
  	project = Project.new(params.except(:categories))

  	project.save

  	array = params[:categories].split(",")
  	array.each do |m|
  		Category.where(:name == m).first_or_create
  	end
  	return project
   end
end