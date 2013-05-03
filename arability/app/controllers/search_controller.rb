class SearchController < BackendController
  before_filter :authenticate_gamer!
  before_filter :authenticate_developer!
  include SearchHelper

  # Author:
  #   Mohamed Ashraf, Nourhan Mohamed
  # Description:
  #   search for keywords (in a particular category)
  # params:
  #   search: a string representing the search keyword, from the params list
  #     from a textbox in the search view
  #   categories: [optional] a string by which the categories can be filtered
  #   project_id: an int indicating a redirection from a specific project
  #     the same id as the int value
  # success: 
  #   returns to the search view a list of keywords (in a certain category)
  #   similar to the search keyword sorted by relevance
  # failure:
  #   returns an empty list if the search keyword had no matches or no
  #   similar keywords were found
  def search_keywords
    @developer_id = Developer.find_by_gamer_id(current_gamer.id).id
    @projects = Project.where(owner_id: @developer_id).all
    @project_id = params[:project_id]
    @search_keyword = params["search"]
    if(!@search_keyword.blank?)
      @search_keyword = @search_keyword.strip
      @search_keyword = @search_keyword.split(" ").join(" ")
      if Keyword.find_by_name(@search_keyword)
        redirect_to search_path, search: @search_keyword
      end
    end
  end
  
  # Author:
  #   Nourhan Mohamed
  # Description:
  #   returns json of keyword names matching autocompletion
  # params:
  #   search_keyword: a string representing the search keyword, from the params list
  #     from a textbox in the search view
  # success:
  #   returns a json list of keywords similar to what's currently typed
  #   in the search textbox
  # failure:
  #   returns an empty list if what's currently typed in the search textbox
  #   had no matches
  def keyword_autocomplete
    search_keyword = params["search"]
    similar_keywords =
      Keyword.get_similar_keywords(search_keyword, [])
    similar_keywords.map! { |keyword| keyword.name }
    render json: similar_keywords
  end

  # Author:
  #   Nourhan Mohamed
  # Description:
  #   submits a report to each of the words chosen in the report form by the
  #   current user
  # params:
  #   reported_words: an array of keywords/synonyms to be reported
  # success:
  #   returns a report with the chosen keywords/synonyms
  # failure:
  #   --
  def send_report
    reported_words = params["reported_words"]
    reported_words = reported_words.to_a
    reported_words.each do |word|
      word = word.split(" ")
      word_model = word[1] == "Keyword" ? 
        Keyword.find(word[0].to_i) : Synonym.find(word[0].to_i)
      @success, _ = Report.create_report(current_gamer, word_model)
    end
  end

  # Author:
  #   Nourhan Mohamed, Nourhan Zakaria
  # Description:
  #   search for synonyms for a particular keyword under certain filters (optional)
  #   calls the helper function that draws the piecharts of voters statistics
  #   of certain synonym
  # params:
  #   search: a string representing the search keyword, from the params list
  #     from a textbox in the search_keywords view
  #   country: a string representing country filter, maybe nil
  #   age_from: a string representing age lower bound filter, maybe nil
  #   age_to: a string representing age upper bound filter, maybe nil
  #   education: a string representing education level filter, maybe nil
  #   gender: a string representing gender filter, maybe nil
  #   synonym_type: an int indicating whether synonyms formal, slang or both
  # success: 
  #   returns to the search view a list of synonyms for the keyword
  #   sorted by vote count according to passed filters
  #   and a list of hashs and in each hash the key is the synonym id
  #   and the value is a list of four pie charts
  # failure:
  #   returns a list of synonyms available for the search keyword, all with 0 
  #   votes or returns to search keywords page if quota was exceeded
  #   No charts will be drawn if the keyword has no synonyms
  def search_with_filters
    @search_keyword = params["search"]
    @project_id = params["project_id"]
    @developer_id = Developer.find_by_gamer_id(current_gamer.id).id
    @projects = Project.where(owner_id: @developer_id).all
    @country = params["country"]
    @age_from = params["age_from"]
    @age_from = @age_from.to_i if !@age_from.blank?
    @age_to = params["age_to"]
    @age_to = @age_to.to_i if !@age_to.blank?
    @gender = params["gender"]
    @education = params["education"]
    @synonym_type = params["synonym_type"]

    if !@age_from.blank? && !@age_to.blank? && @age_from.to_i > @age_to.to_i
      temp = @age_from
      @age_from = @age_to
      @age_to = temp
    end

    if @synonym_type == "0"
      @synonym_type = nil
    elsif @synonym_type == "1"
      @synonym_type = true
    elsif @synonym_type == "2"
      @synonym_type = false
    end

    if !@search_keyword.blank?
      @search_keyword = @search_keyword.strip
      @search_keyword = @search_keyword.split(" ").join(" ")

      @search_keyword_model = Keyword.find_by_name(@search_keyword)
      if !@search_keyword_model.blank?
        
        if !current_developer.my_subscription
          .can_search_word(@search_keyword_model.id)
          
          flash[:error] = t(:search_not_allowed)
          redirect_to search_keywords_path, flash: flash
          return
        end

        @synonyms, @votes =
          @search_keyword_model.retrieve_synonyms(@country, @age_from, 
            @age_to, @gender, @education, @synonym_type)

        @no_synonyms_found = true if @synonyms.blank?

        @total_votes = 0
        @votes.each { |synonym_id, synonym_votes| @total_votes += synonym_votes }

        @categories =
          @search_keyword_model.categories.map { |c| c.get_name_by_locale }

        @category_ids = @search_keyword_model.categories.map { |c| c.id }

        if !@no_synonyms_found
          @charts = @synonyms.map{ |s| { s.id => 
            [piechart_gender(s.id, @gender, @country, @education, @age_from, @age_to), 
            piechart_country(s.id, @gender, @country, @education, @age_from, @age_to),
            piechart_age(s.id, @gender, @country, @education, @age_from, @age_to), 
            piechart_education(s.id, @gender, @country, @education, @age_from,@age_to)] } }
        end 

        if request.xhr?
          render "filtered_results.js"
        end
      else
        redirect_to search_keywords_path(search: @search_keyword)
      end
    else
      redirect_to search_keywords_path
    end
  end
end
