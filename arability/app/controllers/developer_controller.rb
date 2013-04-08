class DeveloperController < ApplicationController
 before_filter :authenticate_gamer!
# author:
#   Khloud Khalid
# description:
#   generates view with form for registration as developer
# params:
#   none
# success:
#   view generated successfully
# failure:
#   gamer not signed in
def new
  if Developer.find_by_gamer_id(current_gamer.id) != nil
    flash[:notice] = "You are already registered as a developer. Don't you remember?"
    render 'pages/home'
  else
    @developer = Developer.new
  end
end
# author:
#   Khloud Khalid
# description:
#   creates new developer using parameters from registration form and renders my_subscription#new
# params:
#   first_name, last_name
# success:
#   developer created successfully
# failure:
#   invalid information, user already registered as developer
def create
  if Developer.find_by_gamer_id(current_gamer.id) != nil
    flash[:notice] = "You are already registered as a developer. Don't you remember?"
    render 'pages/home'
  else
    @developer = Developer.new(params[:developer])
    @developer.gamer_id = current_gamer.id
    if @developer.save
      render 'my_subscription/new'
    else
      flash[:notice] = "Failed to complete registration: Please make sure you entered valid information."
      render :action => 'new'
    end
  end
end
def remove_developer_from_project
    dev = Developer.find(params[:dev_id])
    project = Project.find(params[:project_id])
    project.developers_shared.delete(dev)
    project.save
    flash[:notice] = "Developer Unshared!"
   redirect_to "/developers/projects"
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
    redirect_to "/developers/projects"
  end
end


