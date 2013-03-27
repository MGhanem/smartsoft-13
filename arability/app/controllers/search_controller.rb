class SearchController < ApplicationController
	#Description:
  # Author:
  #   Mohamed Ashraf, Nourhan Mohamed
	#	params:
	#		search: a string representing the search keyword, from the params list from a 
	#     textbox in the search view
  #   categories: [optional] a string by which the categories can be filtered  
	#	returns:
	#		success: 
	#			returns to the search view a list of the keywords (in a certain category) 
	#     similar to the search keyword sorted by relevance
	#		failure:
	#			returns an empty list if the search keyword had no matches or no 
	#     similar keywords were found
  def search
    @categories = params[:categories]
    if @categories.present?
      categories_array = @categories.split(/,/)
      categories_array.reject! {|x| x.blank?}
      categories_array.map! {|x| x.strip}
      categories_array.uniq!
    else
      categories_array = []
    end
    @search_keyword = params['search']
  	@similar_keywords =
      Keyword.get_similar_keywords(@search_keyword, categories_array)
  end
end
