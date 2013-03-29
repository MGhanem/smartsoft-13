class KeywordsController < ApplicationController
  # displays the form for adding a new word
  def new
    @keyword = Keyword.new(params[:name])
  end

  # Create action for keywords
  # @params:
  #   name: the name of the new keyword
  #   redirect: the url to redirect to after the creation defaults to new
  #             keyword path
  #   is_english: the language of the keyword
  # returns:
  #   success: refreshes the page and displays notification
  #   failure: refreshes the page with error displayed
  # author: Mohamed Ashraf
  def create
    redirect_url = params[:redirect]
    if redirect_url.blank?
      redirect_url = keywords_new_path
    end
    name = params[:keyword][:name]
    is_english = params[:keyword][:is_english]
    success, @keyword = Keyword.add_keyword_to_database(name, false, is_english)
    if success
      flash = { :success => "Keyword #{@keyword.name} has been created" }
      redirect_to redirect_url, :flash => flash
    else
      flash = { :error => @keyword.errors.messages }
      redirect_to redirect_url, :flash => flash
    end
  end

  #Description:
  # Author:
  #   Nourhan Mohamed
  # params:
  #   search: a string representing the search keyword that was suggested to
  #     be added to the database
  # returns:
  #   success:
  #     redirects to the search page again after adding the keyword to
  #     database and displays a message indicating successful adding
  #   failure:
  #     returns an error message indicating failure to add
  #     (not implemented as UI yet)
  def suggest_add
    keyword_to_add = params[:search]
    Keyword.add_keyword_to_database(keyword_to_add)
    redirect_to :controller => 'search', :action => 'search',
      :search => keyword_to_add, :suggested => true
  end
end
