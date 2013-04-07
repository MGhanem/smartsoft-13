class ProjectsController < ApplicationController
 # author:Noha hesham
 # Description:
 #   finds the project by its id then destroys it
 # params:
 #   none
 # success:
 #   a pop up appears and makes sure the user wants to
 #   delete the project by choosing ok the 
 #   project is successfully deleted 
 # failure:
 #   project is not deleted
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

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
    if current_gamer != nil 
      developer = Developer.where(:gamer_id => current_gamer.id).first
      if developer != nil
        @projects = Project.where(:developer_id => developer.id)
      else
        flash[:notice] = "Please sign up as a developer first"
        render 'developers/new'
      end
    else
      flash[:notice] = "Please sign in"
      render 'pages/home'
    end  
  	if developer.present?
  		@projects = Project.where(:owner_id => developer.id)
  	else
  		flash[:notice] = "You are not authorized to view this page"
  	end

  end
  # def index
  #   if current_gamer != nil 
  #     developer = Developer.where(:gamer_id => current_gamer.id).first
  #     if developer != nil
  #       @my_projects = Project.where(:owner_id => developer.id)
  #       # @shared_projects = Project.joins(:shared_projects).where(:developer => developer.id)
  #      # @shared_projects = Project.find_by_sql("SELECT * FROM projects INNER JOIN shared_projects ON projects.id = shared_projects.project_id WHERE shared_projects.developer_id = #{developer.id}")
  #     else
  #       flash[:notice] = "Please sign up as a developer first"
  #       render 'developers/new'
  #     end
  #   else
  #     flash[:notice] = "Please sign in"
  #     render 'pages/home'
  #   end  
  # end


  # author:
  #      Salma Farag
  # description:
  #     After checking that the user is signed in, the method that calls method createproject
  #that creates the project and redirects to the project page and prints
  #an error if the data entered is invalid.
  # params:
  #     none
  # success:
  #     Creates a new project and views it in the index page
  # failure:
  #     Gives status errors

  def create
    if gamer_signed_in?
      @project = Project.createproject(params[:project],current_gamer.id)
      respond_to do |format|
        if @project.save
          format.html { redirect_to "/developers/projects", notice: 'Project was successfully created.' }
          format.json { render json: @project, status: :created, location: @project }
        else
          format.html { render action: "new" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
     flash[:error] = "Please log in to view this page."
     render 'pages/home'
   end
 end

  # author:
  #      Salma Farag
  # description:
  #     A method that views the form that  instantiates an empty project object
  # after checking that the user is signed in.
  # params:
  #     none
  # success:
  #     An empty project will be instantiated
  # failure:
  #     none
  def new
    if gamer_signed_in?
      @project = Project.new
      respond_to do |format|
        format.html
        format.json { render json: @project }
      end
    else
      flash[:error] = "Please log in to view this page."
      render 'pages/home'
    end
  end


  def share
    @project = Project.find(params[:id])
  end

  def share_project_with_developer
    @project = Project.find(params[:id])
    gamer = Gamer.find_by_email(params[:email])
    if(!gamer.present?)
      flash[:notice] = "Email doesn't exist"
    else
      developer = Developer.find_by_gamer_id(gamer.id)
      if developer == nil
        flash[:notice] = "Email address is for gamer, not a developer"
      else

        developer.projects_shared << @project
        if(developer.save)
          flash[:notice] = "Project has been shared successfully with #{developer.name}"
        else
          flash[:notice] = "Failed to share project with developer"
        end
      end
    end
    render "projects/share"
  end
  def remove_developer_from_project
    dev = Developer.find(params[:dev_id])
    project = Project.find(params[:project_id])
    project.developers_shared.delete(dev)
    project.save
    flash[:notice] = "Developer Unshared!"
   redirect_to "/projects"
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

  # author:
  #      Salma Farag
  # description:
  #     A method that specifies an already existing project by its ID
  # params:
  #     none
  # success:
  #     A form that contains the existing data of the project will open from the views.
  # failure:
  #     none
  def edit
    if gamer_signed_in?
      @project = Project.find(params[:id])
    else
      flash[:error] = "You are not authorized to view this page"
    end
  end


  # author:
  #      Salma Farag
  # description:
  #     A method that checks if the fields of the form editting the project have been changed.
  #If yes, the new values will replace the old ones otherwise nothing will happen.
  # params:
  #     none
  # success:
  #     An existing project will be updated.
  # failure:
  #     The old values will be kept.
  def update
    if gamer_signed_in?
     @project = Project.find(params[:id])
     @project = Project.createcategories(@project, params[:project][:categories])
     if @project.update_attributes(params.except(:categories,:utf8, :_method,
      :authenticity_token, :project, :commit, :action, :controller, :locale, :id))
      redirect_to :action => "index"
      flash[:notice] = "Project has been successfully updated."
    else
      render :action => 'edit'
    end
  else
    flash[:error] = "You are not authorized to view this page"
  end
end

  # author:
  #      Salma Farag
  # description:
  #     A method that finds a project by its ID to view it.
  # params:
  #     none
  # success:
  #     A project page will open.
  # failure:
  #     None.
def show
  if gamer_signed_in?
    @project = Project.find(params[:id])
  else
    flash[:error] = "You are not authorized to view this page"
  end
end
end

