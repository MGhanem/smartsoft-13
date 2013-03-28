class AdminController < ApplicationController

  before_filter :require_login
  skip_before_filter :require_login, :only => [:login]

  before_filter :check_login, :only => [:login]
  
  # author:
  #     Karim ElNaggar
  # description:
  #     a filter that makes sure the user is logged in
  # params
  #     none
  # success: 
  #     if the user is not logged in redirect to login
  # failure: 
  #     none
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in"
      redirect_to :action => "login"
    end
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     a function that checks if the user is logged in and redirects him to /admin/index
  # params
  #     none
  # success: 
  #     redirect to index if the user is logged in
  # failure: 
  #     none
  def check_login
    if logged_in?
      redirect_to :action => "index"
    end
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     checks if the user is logged in
  # params
  #     none
  # success: 
  #     returns true if the user is logged in as admin
  # failure: 
  #     none
  def logged_in?
    !!current_user
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     current_user method
  # params
  #     none
  # success: 
  #     returns the session variable :who_is_this
  # failure: 
  #     none
  def current_user
    session[:who_is_this]
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     create session method
  # params
  #     none
  # success: 
  #     sets the session variable :who_is_this to "admin"
  # failure: 
  #     none
  def create_session
  	session[:who_is_this] = "admin"
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     destroy_session method
  # params
  #     none
  # success: 
  #     unsets the session variable :who_is_this
  # failure: 
  #     none
  def destroy_session
  	session[:who_is_this] = nil
  end

  def index
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     login action for admin
  # params
  #     username: the username for the admin
  #     password: the password for the admin
  # success: 
  #     redirects to admin/index
  # failure: 
  #     refreshes the page with error displayed
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
  
  # author:
  #     Karim ElNaggar
  # description:
  #     wordadd action for keywords by admin
  # params
  #     name: the name of the new keyword
  # success: 
  #     refreshes the page and displays notification
  # failure: 
  #     refreshes the page with error displayed
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

  # author:
  #     Karim ElNaggar
  # description:
  #     admin logout action
  # params
  #     none
  # success: 
  #     redirects the user to /admin/login page
  # failure: 
  #     none
  def logout
    destroy_session
    redirect_to :action => "login"
  end
end