class AdminController < ApplicationController

  before_filter :require_login
  skip_before_filter :require_login, :only => [:login]

  before_filter :check_login, :only => [:login]
  
  #  returns:
  #    success: if the user is not logged in redirect to login
  #    failure: do nothing
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in"
      redirect_to :action => "login"
    end
  end

  #  returns:
  #    success: redirect to index if the user is logged in
  #    failure: does nothing
  def check_login
    if logged_in?
      redirect_to :action => "index"
    end
  end

  # returns true if the current user is logged in as admin
  def logged_in?
    !!current_user
  end

  # returns the session variable who_is_this
  def current_user
    session[:who_is_this]
  end

  # creates a session with variable who_is_this = "admin"
  def create_session
  	session[:who_is_this] = "admin"
  end

  # clears the session variable who_is_this to nil
  def destroy_session
  	session[:who_is_this] = nil
  end

  def index
  end

  # login action for admin
  # @params:
  #   username: the username for the admin
  #   password: the password for the admin
  # returns:
  #   success: redirects to admin/index
  #   failure: refreshes the page with error displayed
  def login
    if request.post?
    	if params[:username] == "admin" and params[:password] == "admin"
    	  create_session
    	  redirect_to :action => "index"
      else
        flash[:error] = "Invalid username or password"
        @username = params[:username]
    	end
    end
  end

  # wordadd action for keywords by admin
  # @params:
  #   name: the name of the new keyword
  # returns:
  #   success: refreshes the page and displays notification
  #   failure: refreshes the page with error displayed
  def wordadd
    name = params[:keyword][:name]
    is_english = params[:keyword][:is_english]
    success, @keyword = Keyword.add_keyword_to_database(name, false, is_english)
    if success
      flash[:success] = "Keyword #{@keyword.name} has been created"
    else
      flash[:error] = @keyword.errors.messages
    end
    flash.keep
    redirect_to :action => "index"
  end

  # returns:
  #   success: logout the user and redirect to admin login page
  def logout
    destroy_session
    redirect_to :action => "login"
  end
end