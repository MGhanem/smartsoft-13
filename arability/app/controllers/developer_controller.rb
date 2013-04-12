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
      flash[:notice] = t(:already_registered_developer)
      render "pages/home"
    else
      @developer = Developer.new
    end
  end
# author:
#   Khloud Khalid
# description:
#   creates new developer using parameters from registration form and renders my_subscription#new
# params:
#   parameters passed from form(params[:developer]):first_name, last_name
# success:
#   developer created successfully, redirects to choose subscription page
# failure:
#   gamer not signed in, data entered is invalid
  def create
    if Developer.find_by_gamer_id(current_gamer.id) != nil
      flash[:notice] = t(:already_registered_developer)
      render "pages/home"
    else
      @developer = Developer.new(params[:developer])
      @developer.gamer_id = current_gamer.id
      if @developer.save
        redirect_to action: "choose_sub", controller: "my_subscription"
      else
        flash[:notice] = t(:failed_developer_registration)
        render action: "new"
      end
    end
  end
end