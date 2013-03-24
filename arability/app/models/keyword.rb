class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name

  def self.get_similar_keywords(q)
  	keyword_list = self.find(:all, :conditions => ['name LIKE ?', "%#{q}%"])
  	relevant_first_list = keyword_list.sort_by {|keyword| keyword.name.index(q) && keyword.name}
  	return relevant_first_list
  end
end
