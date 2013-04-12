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
      flash[:notice] = t(:already_registered_developer)
      render "pages/home"
    else
      @developer = Developer.new
    end
  end

# author:
#   Khloud Khalid
# description:
#   creates new developer using parameters from registration form and renders my_subscription#new
# params:
#   parameters passed from form(params[:developer]):first_name, last_name
# success:
#   developer created successfully, redirects to choose subscription page
# failure:
#   gamer not signed in, data entered is invalid
  def create
    if Developer.find_by_gamer_id(current_gamer.id) != nil
      flash[:notice] = t(:already_registered_developer)
      redirect_to backend_home_path
    else
      @developer = Developer.new(params[:developer])
      @developer.gamer_id = current_gamer.id
      if @developer.save
        MySubscription.choose(@developer.id,1)
        redirect_to choose_sub_path
      else
        flash[:notice] = t(:failed_developer_registration)
        render action: "new"
      end
    end
  end


  # Author:
  #  Noha Hesham
  # Description:
  #  It removes the project which was shared with the developer 
  #  by finding this developer and the project to be removed
  # params:
  #  none
  # success:
  #  project is unshared successfully
  # failure:
  # project is not removed  
  def remove_developer_from_project
    dev = Developer.find(params[:dev_id])
    project = Project.find(params[:project_id])
    project.developers_shared.delete(dev)
    project.save
    flash[:notice] = flash[:notice] = I18n.t('controller.my_subscription.flash_messages.developer_unshared')
    redirect_to :action => "share",:controller => "projects", :id => params[:project_id]
  end
  # Author:
  #  Noha Hesham
  # Description:
  #  the developer is able to share his project with another developer
  #  by finding this developer and the project to be shared
  # params:
  #  none
  # success:
  #  project is shared successfully
  # failure:
  #  project is not shared with the developer ,and doesnt appear in his 
  #  shared projects tab
  def share_project_with_developer
    @project = Project.find(params[:id])
    gamer = Gamer.find_by_email(params[:email])
    if(!gamer.present?)
      flash[:notice] = I18n.t('controller.my_subscription.flash_messages.Email_doesnt_exist')
      else
       developer = Developer.find_by_gamer_id(gamer.id)
        if developer == nil
         flash[:notice] = I18n.t('controller.my_subscription.flash_messages.Email_for_a_gamer_not_a_developer')
        else
         developer2 = Developer.find_by_gamer_id(current_gamer.id)
        if developer == developer2 
          flash[:notice] = I18n.t('controller.my_subscription.flash_messages.you_cant_share_the_project_with_yourself')
          redirect_to "/developers/projects/#{@project.id}/share"
          return
        end
        if(SharedProject.where("project_id = ? and developer_id = ?", @project.id, developer.id).size > 0)
          flash[:notice] = I18n.t('controller.my_subscription.flash_messages.already_shared')
        else
          developer.projects_shared << @project
           if(developer.save)
            flash[:notice] = I18n.t('controller.my_subscription.flash_messages.project_has_been_successfully_shared')
            redirect_to :action => "share",:controller => "projects", :id => params[:id]
            return
           else
            flash[:notice] = I18n.t('controller.my_subscription.flash_messages.cant_share_the_project')
           end
        end
        end
      end
    end 
    redirect_to "/developers/projects/#{@project.id}/share"
  end
end
