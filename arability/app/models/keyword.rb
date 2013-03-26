class Keyword < ActiveRecord::Base
  attr_accessible :approved, :is_english, :name

	#Description:
	#	params:
	#		search_word: a string representing the search keyword that should be retrieved if found in the database
  #		categories: one or more categories to limit the search to
	#	returns:
	#		success:
	#			returns a list of the keywords (optionally filtered by categories)
  #     similar to the search keyword sorted in lexicographical order
	#		failure:
	#			returns an empty list if the search keyword had no matches or no similar keywords were found
  def self.get_similar_keywords(search_word, categories = [])
  	if (search_word.blank?)
  		return []
  	end
  	keyword_list = where('keywords.name LIKE ?', "%#{search_word}%")
    if categories != []
      keyword_list = 
        keyword_list.joins(:categories)
          .where("categories.name" => categories)
    end
  	relevant_first_list = keyword_list.sort_by {|keyword| keyword.name.index(search_word) && keyword.name}
  	return relevant_first_list
  end
end
