class BackendController < ApplicationController
  layout "backend"
  def home
    redirect_to projects_path
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   checks if developer is signed in or not
  # Params:
  #   current_gamer: the current signed in gamer
  # Success: 
  #   continues as normal 
  # Failure:
  #   redirects to creating new developer
  def authenticate_developer!
    developer = Developer.where(:gamer_id => current_gamer.id).first
  	if developer == nil
  		flash[:notice] = t(:register_developer)
  		redirect_to choose_sub_path
  	end
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   checks if the project the developer is trying to access is in his owned projects or shared
  # Params:
  #   current_gamer: the current signed in gamer
  # Success: 
  #   continues as normal
  # Failure:
  #   redirects back to projects path
  def developer_can_see_this_project?
    developer = Developer.where(:gamer_id => current_gamer.id).first
    projects_owned = Project.where(:owner_id => developer.id)
    projects_shared1 = developer.projects_shared
    current_project = Project.find(params[:id])
    if !projects_owned.include?(current_project) && !projects_shared1.include?(current_project)
      flash[:error] = t(:developer_cant_see_project)
      redirect_to projects_path
    end  
  end

  # Author:
  #   Khloud Khalid
  # Description
  #   checks if the project can be accessed by developer
  # Params:
  #   project_id
  # Success: 
  #   developer can access project
  # Failure:
  #   redirects to projects path with flash error
  def can_access_project?
    developer = Developer.where(gamer_id: current_gamer.id).first
    owned = Project.where(owner_id: developer.id)
    shared = developer.projects_shared
    current_project = Project.find(params[:project_id])
    if !owned.include?(current_project) && !shared.include?(current_project)
      flash[:error] = t(:developer_cant_see_project)
      redirect_to projects_path, flash: flash
    end  
  end
end
