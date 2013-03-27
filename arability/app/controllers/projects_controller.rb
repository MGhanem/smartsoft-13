class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  
  # author: Mohamed Tamer 
  # function shows all the projects of a certain developer
  # params: none
  # returns:
  #     on success: returns an array of projects of the developer currently logged in.
  #     on failure: notifies the user that he can't see this page.
  def index
 	  developer = Developer.where(:gamer_id => current_gamer.id).first
  	if developer.present?
  		@projects = Project.where(:developer_id => developer.id)
  	else
  		flash[:notice] = "You are not authorized to view this page"
  	end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end
end

