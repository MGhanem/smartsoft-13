class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name

	#Description:
	#	params:
	#		search_word: a string representing the search keyword that should be retrieved if found in the database
	#	returns:
	#		success: 
	#			returns a list of the keywords similar to the search keyword sorted in lexicographical order
	#		failure:
	#			returns an empty list if the search keyword had no matches or no similar keywords were found
  def self.get_similar_keywords(search_word)
  	if (search_word.blank?)
  		return []
  	end
    search_word.downcase!
  	keyword_list = self.where("name LIKE ?", "%#{search_word}%")
  	relevant_first_list = keyword_list
      .sort_by {|keyword| [keyword.name.downcase.index(search_word),keyword.name.downcase]}
  	return relevant_first_list
  end 
end