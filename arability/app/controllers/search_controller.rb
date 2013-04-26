class SearchController < BackendController
  before_filter :authenticate_gamer!
  before_filter :authenticate_developer!

  #Description:
  #   search for keywords (in a particular category)
  # Author:
  #   Mohamed Ashraf, Nourhan Mohamed
  # params:
  #   search: a string representing the search keyword, from the params list
  #     from a textbox in the search view
  #   categories: [optional] a string by which the categories can be filtered
  #   is_successful: [optional] a boolean that is passed and set to true if the
  #     controller is accessed due to a redirect from the keyword controller
  # returns:
  #   success: 
  #     returns to the search view a list of keywords (in a certain category)
  #     similar to the search keyword sorted by relevance
  #   failure:
  #     returns an empty list if the search keyword had no matches or no
  #     similar keywords were found
  def search_keywords
    @categories = params[:categories]
    @project_id = params[:project_id]
    if @categories.present?
      categories_array = @categories.split(/,/)
      categories_array.map! { |x| x.strip }
      categories_array.map! { |x| x.downcase }
      categories_array.reject! { |x| x.blank? }
      categories_array.uniq!
    else
      categories_array = []
    end
    @search_keyword = params["search"]
    if(!@search_keyword.blank?)
      @search_keyword = @search_keyword.strip
      @search_keyword = @search_keyword.split(" ").join(" ")
    end
    @similar_keywords =
      Keyword.get_similar_keywords(@search_keyword, categories_array)
    @categories = categories_array
  end

	#Description:
  #   search for synonyms for a particular keyword
  # Author:
  #   Nourhan Mohamed
	#	params:
	#		search: a string representing the search keyword, from the params list
	#     from a textbox in the search_keywords view
	#	returns:
	#		success: 
	#			returns to the search view a list of synonyms for the keyword
	#     sorted by relevance
	#		failure:
	#			returns an empty list if the search keyword has no synonyms
  def search
    @search_keyword = params["search"]
    @project_id = params[:project_id]
    @country = params["country"]
    @age_from = params["age_from"]
    @age_from = @age_from.to_i if !@age_from.blank?
    @age_to = params["age_to"]
    @age_to = @age_to.to_i if !@age_to.blank?
    if !@age_from.blank? && !@age_to.blank? && @age_from > @age_to
      temp = @age_from
      @age_from = @age_to
      @age_to = temp
    end
    @gender = params["gender"]
    @education = params["education"]
    if !@search_keyword.blank?
      @search_keyword = @search_keyword.strip
      @search_keyword = @search_keyword.split(" ").join(" ")
      @no_synonyms_found = false
      @search_keyword_model = Keyword.find_by_name(@search_keyword)
      if !@search_keyword_model.blank?
        @synonyms, @votes =
          @search_keyword_model.retrieve_synonyms(@country, @age_from, @age_to, @gender, @education)
        @no_synonyms_found = true if @synonyms.blank?
        @total_votes = 0
        @votes.each { |synonym_id, synonym_votes| @total_votes += synonym_votes }
      else
        redirect_to search_keywords_path(search: @search_keyword)
      end
    else
      redirect_to search_keywords_path
    end
  end
end
