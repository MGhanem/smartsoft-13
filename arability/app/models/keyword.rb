class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name
 
  def self.get_similar_keywords(search_word)
  	keyword_list = self.find(:all, :conditions => ['name LIKE ?', "%#{search_word}%"])
  	relevant_first_list = keyword_list.sort_by {|keyword| keyword.name.index(search_word) && keyword.name}
  	return relevant_first_list
  end
end
