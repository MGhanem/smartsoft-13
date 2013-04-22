class DeveloperController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_gamer!

  # author:
  #   Khloud Khalid
  # description:
  #   creates new developer for the current gamer with the subscription mmodel initially set to free trial then redirects 
  #   to the page where the user chooses his/her subscription model.
  # params:
  #   none
  # success:
  #   developer created successfully, redirects to choose subscription page
  # failure:
  #   gamer not signed in
  def new
    if developer_signed_in?
      flash[:notice] = t(:already_registered_developer)
      redirect_to projects_path
    else
      @developer = Developer.new
      @developer.gamer_id = current_gamer.id
      if @developer.save
        MySubscription.choose(@developer.id, SubscriptionModel.first.id)
        redirect_to choose_sub_path
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
    redirect_to "/developers/projects/#{@project.id}/share"
  end 
end
