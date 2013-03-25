class KeywordsController < ApplicationController
  def new
    @keyword = Keyword.new(params[:name])
  end

  # Create action for keywords
  # @params:
  #   name: the name of the new keyword
  #   redirect: the url to redirect to after the creation
  # author: Mohamed Ashraf
  def create
    redirect_url = params[:redirect]
    if ! redirect_url
      redirect_url = keywords_new_path
    end
    name = params[:keyword][:name]
    is_english = params[:keyword][:is_english]
    success, @keyword = Keyword.add_keyword_to_database(name, false, is_english)
    if success
      flash = { :success => "Keyword #{@keyword.name} has been created" }
      redirect_to redirect_url, :flash => flash
    else
      flash = { }
      render :new, :error => @keyword.errors
    end
  end

  def viewall
    @keywords = Keyword.all
  end

  def deleteall
    Keyword.delete_all
    redirect_to keywords_path, :flash => {:success => "All keywords have been deleted" }
  end
end
