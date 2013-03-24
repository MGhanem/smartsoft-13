class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name

  def self.get_similar_keywords(q)
  	keyword_list = self.find(:all, :conditions => ['name LIKE ?', "%#{q}%"])
  	sorted_by_relevance_list = keyword_list.sort_by {|keyword| keyword.index(q)}
  	return sorted_by_relevance_list
  end
end
