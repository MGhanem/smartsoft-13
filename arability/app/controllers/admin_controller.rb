class AdminController < ApplicationController

  before_filter :require_login
  before_filter :check_login, :only => [:login]
  skip_before_filter :require_login, :only => [:login]

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in"
      redirect_to :action => "login"
    end
  end

  def check_login
    if logged_in?
      redirect_to :action => "index"
    end
  end

  def logged_in?
    !!current_user
  end

  def current_user
    session[:who_is_this]
  end

  def create_session
  	session[:who_is_this] = "admin"
  end

  def destroy_session
  	session[:who_is_this] = nil
  end

  def index
  end

  def login
  	if params[:username] == "admin" and params[:password] == "admin"
  	  create_session
  	  redirect_to :action => "index"
  	end
  end

  def logout
    destroy_session
    redirect_to :action => "login"
  end
end
