class Developer < ActiveRecord::Base
 belongs_to :gamer
 has_and_belongs_to_many :keywords


  
  has_one :my_subscription

  has_many :shared_projects
  has_many :projects_shared, :through => :shared_projects, :source => "project"
  has_many :projects, :foreign_key => "owner_id"



 # has_many :own_projects, :class_name => "Project"
 # has_and_belongs_to_many :shared_with_projects, :class_name => "Project"


 attr_accessible :first_name, :last_name, :verified, :gamer_id
 validates :first_name, :presence => true
 validates :last_name, :presence => true
 validates_format_of :first_name, :with => /\A[a-zA-Z]+\z/
 validates_format_of :last_name, :with => /\A[a-zA-Z]+\z/
 validates_length_of :first_name, :maximum => 18
 validates_length_of :first_name, :minimum => 3
 validates_length_of :last_name, :maximum => 18
 validates_length_of :last_name, :minimum => 3
 validates :gamer_id, :presence => true, :uniqueness => true


  def follow(keyword_id)
      developer = Developer.find(self.id)
      keyword = Keyword.find(keyword_id)
      developer.keywords << keyword
  end

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
