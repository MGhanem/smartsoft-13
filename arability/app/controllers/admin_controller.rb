class AdminController < ApplicationController

  # require login from the user to do any action
  before_filter :require_login

  # checks if the user is logged in to avoid displaying the login page
  before_filter :check_login, :only => [:login]
  
  # to view the login page it is not required to be logged in
  skip_before_filter :require_login, :only => [:login]

  # if the user is not logged in he will be redirect to login page and 
  # notified via flash message
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in"
      redirect_to :action => "login"
    end
  end

  # checks if the current user is logged in and redirects him to index page
  def check_login
    if logged_in?
      redirect_to :action => "index"
    end
  end

  # returns if the current user is actually logged in
  def logged_in?
    !!current_user
  end

  # returns the variable who_is_this
  def current_user
    session[:who_is_this]
  end

  # sets the variable who_is_this to "admin" to indicate admin logged in
  def create_session
  	session[:who_is_this] = "admin"
  end

  # removes the variable who_is_this from the session to log out
  def destroy_session
  	session[:who_is_this] = nil
  end

  def index
  end

  # check if request is a post request
  # if it is a post request and the username and password are correct
  # will create a session to store the admin state
  # and will redirect to the index page of admin
  # if it is incorrect username or password the user will
  # have a flash telling him that it is incorrect
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

  # destroyes the session of the user and redirects him to login action
  def logout
    destroy_session
    redirect_to :action => "login"
  end
end