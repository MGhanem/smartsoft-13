class SearchController < BackendController
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
    @project_id = params['project_id']
    @country = params['country']
    @age_from = params['age_from']
    if(!@age_from.blank?)
      @age_from = @age_from.to_i
    end
    @age_to = params['age_to']
    if(!@age_to.blank?)
      @age_to = @age_to.to_i
    end
    @gender = params['gender']
    if(@search_keyword.blank? && @search_keyword_model.blank?)
      @display_add = false
    end
    if(!@search_keyword.blank?)
      @no_synonyms_found = false
      @search_keyword_model = Keyword.find_by_name(@search_keyword)
      if(!@search_keyword_model.blank?)
        @synonyms, @votes =
          @search_keyword_model.retrieve_synonyms(@country, @age_from, @age_to, @gender)
          if(@synonyms.blank?)
            @no_synonyms_found = true
          end
        @total_votes = 0
        @votes.each do |synonym_id, synonym_votes|
          @total_votes += synonym_votes
        end
      else
        @display_add = true
      end

    if(!@search_keyword.blank?)
      @synonyms =
        Synonym.retrieve_synonyms(@search_keyword)
    end
  end
end
