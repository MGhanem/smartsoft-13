class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  
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
  		@my_projects = Project.where(:owner_id => developer.id)
      @shared_projects = developer.projects_shared
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

  def share
    @project = Project.find(params[:id])
  end

  # def share_project_with_developer
  #   @project = Project.find(params[:id])
  #   gamer = Gamer.find_by_email(params[:email])
  #   if(!gamer.present?)
  #     flash[:notice] = "Email doesn't exist"
  #   else
  #     developer = Developer.find_by_gamer_id(gamer.id)
  #     if developer == nil
  #       flash[:notice] = "Email address is for gamer, not a developer"
  #     else

  #       developer.projects_shared << @project
  #       if(developer.save)
  #         flash[:notice] = "Project has been shared successfully with #{developer.name}"
  #       else
  #         flash[:notice] = "Failed to share project with developer"
  #       end
  #     end
  #   end
  #   render "projects/share"
  # end
  # def remove_developer_from_project
  #   dev = Developer.find(params[:dev_id])
  #   project = Project.find(params[:project_id])
  #   project.developers_shared.delete(dev)
  #   project.save
  #   flash[:notice] = "Developer Unshared!"
  #  redirect_to "/projects"
  # end



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
  def show
  end
end
