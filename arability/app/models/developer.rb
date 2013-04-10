class Developer < ActiveRecord::Base
 belongs_to :gamer
 attr_accessible :first_name, :last_name, :verified, :gamer_id
 validates :first_name, :presence => true
 validates :last_name, :presence => true
 validates_format_of :first_name, :with => /\A[a-zA-Z]+\z/
 validates_format_of :last_name, :with => /\A[a-zA-Z]+\z/
 validates_length_of :first_name, :maximum => 18
 validates_length_of :first_name, :minimum => 3
 validates_length_of :last_name, :maximum => 18
 validates_length_of :last_name, :minimum => 3
 validates :gamer_id, :presence => true, :uniqueness => 


  #mostafa hassaan
  def follow(keyword_id)
      developer = Developer.find(self.id)
      keyword = Keyword.find(keyword_id)
      developer.keywords << keyword
  end

  # author:
  #   Mostafa Hassaan
  # description:
  #     function removes relation between a develoepr and a keyword
  # params:
  #     keyword_id: id of the keyword to unfollow
  # success:
  #     returns true on removing the relation between the developer and the keyword
  # failure:
  #     returns false if there was no keywords matching the keyword_id in 
  #       the database
  def unfollow(keyword_id)
      developer = Developer.find(self.id)
      keyword = Keyword.find(keyword_id)
      developer.keywords.delete(keyword)
  end
end
