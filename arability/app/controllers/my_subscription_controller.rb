class MySubscriptionController < ApplicationController
  before_filter :authenticate_gamer!
# author:
#   Khloud Khalid
# description:
#   generates view with form for choosing subscription model
# params:
#   none
# success:
#   view generated successfully
# failure:
#   gamer not signed in  
  def new
    if MySubscription.find_by_developer_id(Developer.find_by_gamer_id(current_gamer.id).id) == nil
      if Developer.find_by_gamer_id(current_gamer.id) != nil
        @my_subscription = MySubscription.new
      else
        flash[:notice] = t(:no_developer)
        render 'pages/home'
      end
    else
      flash[:notice] = t(:subscription_model_already_chosen)
      render 'pages/home'
    end
  end
# author:
#   Khloud Khalid
# description:
#   creates new my_subscription using parameters from registration form and links it to the developer
# params:
#   subscription_model_id
# success:
#   my_subscription created successfully and linked to developer
# failure:
#   invalid information
  def create
    if Developer.find_by_gamer_id(current_gamer.id) != nil
      if MySubscription.find_by_developer_id(Developer.find_by_gamer_id(current_gamer.id).id) == nil
        if SubscriptionModel.find_by_id(params[:my_subscription]) != nil
          @my_subscription = MySubscription.new
          @my_subscription.developer_id = Developer.find_by_gamer_id(current_gamer.id).id
          @my_subscription.subscription_models_id = params[:my_subscription]
          if @my_subscription.save
            flash[:notice] = t(:success_developer_registration:)
            redirect_to projects_path, :flash => flash
            return
          else
            flash[:notice] = t(:failed_developer_registration)
            render 'my_subscription/new'
          end
        else
          if params[:my_subscription] == nil
            flash[:notice] = t(:choose_subscription_model)
            render 'my_subscription/new'
          else
            flash[:notice] = t(:subscription_model_does_not_exist)
            render 'my_subscription/new'
          end
        end
      else
        flash[:notice] = t(:subscription_model_already_chosen)
        render 'pages/home'
      end
    else
      flash[:notice] = t(:no_developer)
      render 'pages/home'
    end  
  end
end
