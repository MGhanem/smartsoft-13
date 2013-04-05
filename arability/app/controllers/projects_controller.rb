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
      if gamer_signed_in?
        @projects = Project.where(:owner_id => current_gamer.id)
      else
        flash[:error] = "You are not authorized to view this page"
        render 'pages/home'
      end
    end

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
          format.html { redirect_to "/projects", notice: 'Project was successfully created.' }
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
     @project = Project.createcategories(@project, params([:project][:categories]))
     if @project.update_attributes(params[:project])
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