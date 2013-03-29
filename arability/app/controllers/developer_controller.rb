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
  @developer = Developer.new
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
  @developer = Developer.new(params[:developer])
  @developer.gamer_id = current_gamer.id
  if @developer.save
    render 'my_subscription/new'
    else
      if((Developer.find_by_gamer_id(current_gamer.id)) != nil)
        flash[:notice] = "You are already registered as a developer."
        render :action => 'new'
        else
          flash[:notice] = "Failed to complete registration: Please make sure you entered valid information."
          render :action => 'new'
      end
  end
end
end


