class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
  	 @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end
end

