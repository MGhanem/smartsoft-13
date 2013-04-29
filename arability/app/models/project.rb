#encoding: UTF-8
class Project < ActiveRecord::Base
  has_one :owner, :class_name => "Developer"
  has_many :shared_projects
  has_many :developers_shared, :through => :shared_projects, :source => "developer"
  belongs_to :category
  has_many :keywords, :through => :prefered_synonym
  attr_accessible :description, :formal, :maxAge, :minAge, :name, :category, :country, :education_level
  validates :name, :presence => true,:length => { :maximum => 30 }
  validates :minAge, :inclusion => { :in => 9..99,  :message => :minAge_range }
  validates :maxAge, :inclusion => { :in => 10..100,  :message => :maxAge_range }, :numericality => { :greater_than_or_equal_to => :minAge, :message => :less_than_minAge}

# Author:
#   Salma Farag
# Description:
#   Takes the params of the project entered by the developer, sets the developer_id to the current
#   one then creates a project then calls the method createcategories and returns a  project.
# Params:
#   Parameters of a project including :description, :formal, :maxAge, :minAge, :name, :category
#   and and the current developer id.
# Success:
#   Creates and returns a project after calling method createcategories.
# Failure:
#   None
def self.createproject(params,developer_id)
  project = Project.new(params.except(:developer,:category))
  project.owner_id = developer_id
  project = createcategories(project,params[:category])
  return project
end

# Author:
#   Salma Farag
# Description:
#   A method that takes a category in the form of a string and saves it in an array
#   then finds the category with the id equal to the given id.
# Params:
#   Parameters of a project including :description, :formal, :maxAge, :minAge, :name, :category
#   and its category id.
# Success:
#   Sets the category of the project to an existing one by finding the equivalent id.
# Failure:
#   None
def self.createcategories(project,cat_id)
  if cat_id != " "
    catArray = []
    catArray.push(cat_id)
    catArray.each do |m|
      project.category = Category.find(cat_id)
    end
    project.save
  end
  return project
end
end
