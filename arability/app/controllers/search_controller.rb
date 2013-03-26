class SearchController < ApplicationController
	#Description:
	#	params:
	#		q: a string representing the search keyword, from the params list from a 
	#      textbox in the search view
	#	returns:
	#		success: 
	#			returns to the search view a list of the keywords similar to the search
	#     keyword sorted in lexicographical order
	#		failure:
	#			returns an empty list if the search keyword had no matches or no 
	#     similar keywords were found
  def search
    categories = params[:categories]
    if categories.present?
      categories = categories.split /\s*,\s*/
  	@similar_keywords = Keyword.get_similar_keywords(params['q'])
  end
end