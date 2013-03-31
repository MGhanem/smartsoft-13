class ProjectsController < ApplicationController 
  # author: 
  #   Mohamed Tamer 
  # description: 
  #   function shows all the projects of a certain developer
  # params: 
  #   none
  # returns:
  #   on success: returns an array of projects of the developer currently logged in.
  #   on failure: notifies the user that he can't see this page.
  def index
    developer = Developer.where(:gamer_id => current_gamer.id).first
    if developer.present?
      @projects = Project.where(:developer_id => developer.id)
    else
      flash[:notice] = "You are not authorized to view this page"
    end
  end

# author:
#      Salma Farag
# description:
#     A method that calls method createproject that creates the project and redirects to the
#project page and prints an error if the data entered is invalid
# params:
#     none
# success:
#     Creates a new project and views it in the index page
# failure:
#     Gives status errors

def create
  @project = Project.createproject(params[:project])
  respond_to do |format|
    if @project.save
      format.html { redirect_to "/projects", notice: 'Project was successfully created.' }
      format.json { render json: @project, status: :created, location: @project }
    else
      format.html { render action: "new" }
      format.json { render json: @project.errors, status: :unprocessable_entity }
    end
  end
end

# author:
#      Salma Farag
# description:
#     A method that views the form that  instantiates an empty project object
# params:
#     none
# success:
#     An empty project will be instantiated
# failure:
#     none
def new
  @project = Project.new
  respond_to do |format|
    format.html
    format.json { render json: @project }
  end
end
end