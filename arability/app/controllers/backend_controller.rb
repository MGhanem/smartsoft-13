class BackendController < ApplicationController
  layout "backend"
  def home
    redirect_to projects_path
  end
  def authenticate_developer!
    developer = Developer.where(:gamer_id => current_gamer.id).first
  	if developer == nil
  		flash[:notice] = t(:register_developer)
  		redirect_to developers_new_path
  	end
  end
end
