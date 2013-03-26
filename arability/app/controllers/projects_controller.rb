class ProjectsController < ApplicationController
  # function shows all the projects of a certain developer
  # params: none
  # returns:
  #     on success: returns an array of projects of the developer currently logged in.
  #     on failure: returns an empty array and notifies the user that he can't see this page.
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

  #A method that calls method createproject that creates the project and redirects to the
  #project page and prints an error if the data entered is invalid
  def create
    @project = Project.createproject(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end

  #def new
  #  @project = Project.new

   # respond_to do |format|
    #  format.html
     # format.json { render json: @project }
    #end
  #end

  #def edit
   # @project = Project.find(params[:id])
  #end


 # def update
  #  @project = Project.find(params[:id])

   # respond_to do |format|
    #  if @project.update_attributes(params[:project])
     #   format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      #  format.json { head :no_content }
      #else
       # format.html { render action: "edit" }
        #format.json { render json: @project.errors, status: :unprocessable_entity }
      #end
    #end
  #end
end