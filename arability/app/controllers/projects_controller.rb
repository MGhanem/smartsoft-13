class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
 	@developer = Developer.where(:gamer_id => current_gamer.id).first
  	if @developer.present?
  		@projects = Project.where(:developer => @developer.id)
  	else
  		flash[:notice] = "You are not authorized to view this page"
  	end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end
end

