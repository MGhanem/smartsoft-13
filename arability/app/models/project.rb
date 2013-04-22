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
#   Creates and returns a project after splitting the csv categories string and creating
#   new categories and inserting them into the project categories array
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
#   A method that takes categories in the form of csv and saves them in an array
#   then loops on it and creates an a new category each time.
# Params:
#   Category names in the form of csv.
# Success:
#   Categories will be created.
# Failure:
#   None
def self.createcategories(project,cat_id)
  array = cat_id.split(/\s*[,;]\s*|\s{2,}|[\r\n]+/x)
  catArray = []
  array.each do |m|
    cat = Category.find("1")
    project.category = cat
  end
  project.save
  return project
end

# Author:
#   Salma Farag
# Description:
#   A method that takes an array of categories, maps their names into an array and joins
#   the array using commas.
# Params:
#   Array of categories.
# Success:
#   Returns a string of category names.
# Failure:
#   None
def self.printarray(array)
  t = array.map {|item| item.name}
  t = t.join(", ")
  return t
end

end
