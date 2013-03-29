class SearchController < ApplicationController
	#Description:
  # Author:
  #   Mohamed Ashraf, Nourhan Mohamed
	#	params:
	#		search: a string representing the search keyword, from the params list
	#     from a textbox in the search view
  #   categories: [optional] a string by which the categories can be filtered
  #   is_successful: [optional] a boolean that is passed and set to true if the
  #     controller is accessed due to a redirect from the keyword controller
	#	returns:
	#		success: 
	#			returns to the search view a list of keywords (in a certain category)
	#     similar to the search keyword sorted by relevance
	#		failure:
	#			returns an empty list if the search keyword had no matches or no
	#     similar keywords were found
  def search
    @categories = params[:categories]
    if @categories.present?
      categories_array = @categories.split(/,/)
      categories_array.reject! { |x| x.blank? }
      categories_array.map! { |x| x.strip }
      categories_array.uniq!
    else
      categories_array = []
    end
    @is_successful = params['is_successful']
    @search_keyword = params['search']
  	@similar_keywords =
      Keyword.get_similar_keywords(@search_keyword, categories_array)
  end
end
