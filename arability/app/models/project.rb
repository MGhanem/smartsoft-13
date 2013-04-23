#encoding: UTF-8
class Project < ActiveRecord::Base
  has_and_belongs_to_many :shared_with, :class_name => "Developer"
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
#   Takes the params of the project entered by the developer and creates a project compares
#   it to the already existing categories and returns the project
# Params:
#   :project
# Success:
#   Creates and returns a project after calling method createcategories
# Failure:
#   None
def self.createproject(params)
  project = Project.new(params.except(:developer,:category))
  project = createcategories(project,params[:category])
  return project
end

# Author:
#    Salma Farag
# Description:
#   A method that takes category in the form of a string and saves them in an array
#   then finds the category with the id = cat_id
# Params:
#   A project and its category id.
# Success:
#   Sets the category of the project to an existing one by finiding the equivalent id.
# Failure:
#   None
def self.createcategories(project,cat_id)
  array = cat_id.split(/\s*[,;]\s*|\s{2,}|[\r\n]+/x)
  catArray = []
  array.each do |m|
    cat = Category.find(cat_id)
    project.category = cat
  end
  project.save
  return project
end

end
