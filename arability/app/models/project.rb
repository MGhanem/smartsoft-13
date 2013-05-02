#encoding: UTF-8
class Project < ActiveRecord::Base
  has_one :owner, :class_name => "Developer"
  has_many :shared_projects
  has_many :developers_shared, :through => :shared_projects, :source => "developer"

  belongs_to :category
  has_many :keywords, :through => :prefered_synonym
  attr_accessible :description, :formal, :maxAge, :minAge, :name, :category
  validates :name, :presence => true,:length => { :maximum => 30 }
  validates :minAge, :presence => true, :inclusion => { :in => 9..99 }
  validates :maxAge, :presence => true, :inclusion => { :in => 10..100 }, :numericality => { :only_integer => true,:greater_than_or_equal_to => :minAge}

# Author:
#   Salma Farag
# Description:
#   Takes the params of the project entered by the developer, creates a project then calls
#   the method createcategories and returns a  project.
# Params:
#   Parameters of a project.
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
#    Salma Farag
# Description:
#   A method that takes a category in the form of a string and saves it in an array
#   then finds the category with the id equal to the given id.
# Params:
#   A project and its category id.
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
