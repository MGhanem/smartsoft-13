class SearchController < ApplicationController
	#Description:
  #   search for keywords (in a particular category)
  # Author:
  #   Nourhan Mohamed
	#	params:
	#		search: a string representing the search keyword, from the params list
	#     from a textbox in the search view
	#	returns:
	#		success: 
	#			returns to the search view a list of synonyms for the keyword
	#     sorted by relevance
	#		failure:
	#			returns an empty list if the search keyword had synonyms
  def search
    @search_keyword = params['search']
    if(!@search_keyword.blank?)
      @search_keyword_model = Keyword.find_by_name(@search_keyword)
      @synonyms, @votes =
        @search_keyword_model.retrieve_synonyms()
    end
  end
end
