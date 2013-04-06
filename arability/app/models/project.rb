#encoding: UTF-8
class Project < ActiveRecord::Base
  belongs_to :developer
  has_and_belongs_to_many :categories
  has_many :keywords, :through => :prefered_synonyms
  attr_accessible :description, :formal, :maxAge, :minAge, :name, :categories
  validates :name, :presence => true,:length => { :maximum => 30 }
  validates :minAge, :presence => true, :inclusion => { :in => 9..99, :message => "is not in range" }
  validates :maxAge, :presence => true, :inclusion => { :in => 10..100, :message => "is not in range" }, :numericality => { :only_integer => true,:greater_than_or_equal_to => :minAge}

# author:
#      Salma Farag
# description:
#      Takes the params of the project entred by the developer and creates a project compares
#it to the already existing categories and returns the project
# params:
#     :project
# success:
#     Creates and returns a project after splitting the csv categories string and creating
#new categories and inserting them into the project categories array
# failure:
#     None
 
  def self.createproject(params)
  	project = Project.new(params.except(:categories))
  	array = params[:categories].split(/\s*[,;]\s*|\s{2,}|[\r\n]+/x)
    catArray = []
  	array.each do |m|
      catArray.push(Category.where(:name => m).first_or_create)
  	end
    project.categories = catArray
    project.save
  	return project
   end
end