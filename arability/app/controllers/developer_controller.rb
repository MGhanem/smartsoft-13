class DeveloperController < ApplicationController
  before_filter :authenticate_gamer!
# author:
#   Khloud Khalid
# description:
#   generates view with form for registration as developer
# params:
#   none
# success:
#   view generated successfully
# failure:
#   gamer not signed in
  def new
    if Developer.find_by_gamer_id(current_gamer.id) != nil
      flash[:notice] = "You are already registered as a developer. Don't you remember?"
      render 'pages/home'
    else
      @developer = Developer.new
    end
  end
# author:
#   Khloud Khalid
# description:
#   creates new developer using parameters from registration form and renders my_subscription#new
# params:
#   first_name, last_name
# success:
#   developer created successfully
# failure:
#   invalid information, user already registered as developer
  def create
    if Developer.find_by_gamer_id(current_gamer.id) != nil
      flash[:notice] = "You are already registered as a developer. Don't you remember?"
      render 'pages/home'
    else
      @developer = Developer.new(params[:developer])
      @developer.gamer_id = current_gamer.id
      if @developer.save
        render 'my_subscription/new'
      else
        flash[:notice] = "Failed to complete registration: Please make sure you entered valid information."
        render :action => 'new'
      end
    end
  end

  def follow
    dev_id = Developer.where(:gamer_id => current_gamer.id).first.id
    Developer.follow(dev_id, #keyword_id)
  end

  def unfollow
    dev_id = Developer.where(:gamer_id => current_gamer.id).first.id
    Developer.unfollow(dev_id, #keyword_id)
  end


  def followed
    if current_gamer != nil 
      developer = Developer.where(:gamer_id => current_gamer.id).first
      if developer != nil
        keyword_ids_array = developer.keyword_ids
        @keywords = Keyword.find_all_by_id(keyword_ids_array)
        render 'developer/followed'
      else
        flash[:notice] = "Please sign up as a developer first"
        render 'developers/new'
      end
    else
      flash[:notice] = "Please sign in"
      render 'pages/home'
    end  
  end
end


