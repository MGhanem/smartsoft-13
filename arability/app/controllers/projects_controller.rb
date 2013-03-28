class ProjectsController < ApplicationController
 
  def index
    @projects = Project.all

    respond_to do |format|
      format.html 
      format.json { render json: @projects }
    end
  end

  
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html 
      format.json { render json: @project }
    end
  end

  
  def new
    @project = Project.new

    respond_to do |format|
      format.html 
      format.json { render json: @project }
    end
  end

  def create
    @project = Project.new(params[:project])

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

  

  # DELETE /projects/1
  # DELETE /projects/1.json
 # author:Noha
 # Description:
 #   finds the project by its id then destroys it
 # params:
 #   none
 # success:
 #   a pop up appears and makes sure the user wants to delete the project
 #   by choosing ok the project is successfully deleted 
 # failure:
 #    project is not deleted


  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
