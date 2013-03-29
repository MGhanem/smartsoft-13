class ProjectsController < ApplicationController
  # DELETE /projects/1
  # DELETE /projects/1.json
 # author:Noha hesham
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
