#encoding: UTF-8
class Developer < ActiveRecord::Base
  belongs_to :gamer 
  has_one :my_subscription


  has_and_belongs_to_many :keywords


  has_many :shared_projects
  has_many :projects_shared, :through => :shared_projects, :source => "project"
  has_many :projects, :foreign_key => "owner_id"


  has_many :own_projects, class_name: "Project"
  has_and_belongs_to_many :shared_with_projects, class_name: "Project"

  attr_accessible :verified, :gamer_id

  validates :gamer_id, presence: true, uniqueness: true




  # author:
  #   Mostafa Hassaan
  # description:
  #   function creates relation between a develoepr and a keyword
  # params:
  #   keyword_id: id of the keyword to follow
  # success:
  #   returns true on saving the relation between the developer and the keyword
  # failure:
  #   returns false if there was not keywords matching the keyword_id in 
  #   the database
  def follow(keyword_id)
      developer = Developer.find(self.id)
      keyword = Keyword.find(keyword_id)
      developer.keywords << keyword
  end
  
  # author:
  #   Mostafa Hassaan
  # description:
  #   function removes relation between a develoepr and a keyword
  # params:
  #   keyword_id: id of the keyword to unfollow
  # success:
  #   returns true on removing the relation between the developer and the keyword
  # failure:
  #   returns false if there was no keywords matching the keyword_id in 
  #   the database
  def unfollow(keyword_id)
      developer = Developer.find(self.id)
      keyword = Keyword.find(keyword_id)
      developer.keywords.delete(keyword)
  end

 def email
 	self.gamer.email
 end
 def name
  self.first_name + " " + self.last_name

end
end
