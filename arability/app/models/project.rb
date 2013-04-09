#encoding: UTF-8
class Project < ActiveRecord::Base

  has_and_belongs_to_many :shared_with, :class_name => "Developer"
  # has_one :owner, :class_name => "Developer"
  has_many :shared_projects
  has_many :developers_shared, :through => :shared_projects, :source => "developer"




  attr_accessible :name
  belongs_to :developer




  has_and_belongs_to_many :categories
  has_many :keywords, :through => :prefered_synonym
  attr_accessible :description, :formal, :maxAge, :minAge, :name, :categories
  validates :name, :presence => true,:length => { :maximum => 30 }
  validates :minAge, :presence => true, :inclusion => { :in => 9..99, :message => "is not in range" }
  validates :maxAge, :presence => true, :inclusion => { :in => 10..100, :message => "is not in range" }, :numericality => { :only_integer => true,:greater_than_or_equal_to => :minAge}

# author:
#      Salma Farag
# description:
#      Takes the params of the project entered by the developer and creates a project compares
#it to the already existing categories and returns the project
# params:
#     :project
# success:
#     Creates and returns a project after splitting the csv categories string and creating
#new categories and inserting them into the project categories array
# failure:
#     None


 
  # def self.createproject(params)
  # 	project = Project.new(params.except(:categories))
  # 	array = params[:categories].split(/\s*[,;]\s*|\s{2,}|[\r\n]+/x)
  #   catArray = []
  # 	array.each do |m|
  #     catArray.push(Category.where(:name => m).first_or_create)
  # 	end
  #   project.categories = catArray
  #   project.save
  # 	return project
  #  end


def self.createproject(params,developer_id)
  project = Project.new(params.except(:categories,:developer))
  project.owner_id = developer_id
  project = createcategories(project,params[:categories])
  return project
end

  # author:
  #      Salma Farag
  # description:
  #     A method that takes categories in the form of csv and saves them in an array
  #then loops on it and creates an a new category each time.
  # params:
  #     Category names in the form of csv.
  # success:
  #     Categories will be created.
  # failure:
  #     none
def self.createcategories(project,categories)
  array = categories.split(/\s*[,;]\s*|\s{2,}|[\r\n]+/x)
  catArray = []
  array.each do |m| m.capitalize!
    catArray.push(Category.where(:name => m).first_or_create)
  end
  project.categories = catArray
  project.save
  return project
end

  # author:
  #      Salma Farag
  # description:
  #     A method that takes an array of categories, maps their names into an array and joins
  #the array using commas.
  # params:
  #     Array of categories.
  # success:
  #     Returns a string of category names.
  # failure:
  #     None
def self.printarray(array)
  t = array.map {|item| item.name}
  t = t.join(", ")
  return t
end
end
