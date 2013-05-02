#encoding: UTF-8
class MySubscriptionController < ApplicationController
  before_filter :authenticate_gamer!
  #before_filter :prepare_subscriptions, :only => [:choose_sub, :pick]
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
        @my_subscription.save
      else
        flash[:notice] = "Please register as a developer before you choose your subscription model."
        render 'pages/home'
      end
    else
      flash[:notice] = "You have already chosen your subscription model."
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
        if Subscrip
          tionModel.find_by_id(params[:my_subscription]) != nil
          @my_subscription = MySubscription.new
          @my_subscription.developer_id = Developer.find_by_gamer_id(current_gamer.id).id
          @my_subscription.subscription_models_id = params[:my_subscription]
          if @my_subscription.save
            flash[:notice] = "You have successfully registered as a developer."
            render 'pages/home'
          else
            flash[:notice] = "Failed to complete registration."
            render 'my_subscription/new'
          end
        else
          if params[:my_subscription] == nil
            flash[:notice] = "Please choose a subscription model."
            render 'my_subscription/new'
          else
            flash[:notice] = "Failed to complete registration: the subscription model you chose does not exist."
            render 'my_subscription/new'
          end
        end
      else
        flash[:notice] = "You have already chosen your subscription model. Don't you remember?"
        render 'pages/home'
      end
    else
      flash[:notice] = "Please register as a developer before you choose your subscription model."
      render 'pages/home'
    end  
  end
  # Author:
  #   Noha Hesham
  # Description:
  #   Gets all the subscription models available and finds the the current 
  #   developer by the gamer id
  # Params:
  #   None
  # Success:
  #   All subscription models are listed
  # Failure:
  #   Subscription models are not listed
  def choose_sub
    @all_subscription_models = SubscriptionModel.all
    @developer = Developer.find_by_gamer_id(current_gamer.id)
  end
  # Author:
  #   Noha Hesham
  # Description:
  #   Allows the current developer to choose his subscription model 
  #   and the limits are added to his my subscription
  # Success:
  #   The developer can choose his subscription model successfully
  # Failure:
  #   Payment issues
  def pick
    @all_subscription_models = SubscriptionModel.all
    @developer = Developer.new
    @developer.gamer_id = current_gamer.id
    @developer.save
    sub_id = params[:my_subscription]
    dev_id = @developer.id
    if MySubscription.choose(dev_id, sub_id)
      flash[:success] = I18n.t('controller.subscription.messages_errors.you_have_successfully_chosen_your_model') 
      redirect_to projects_path
    else
      flash[:notice] = I18n.t('controller.subscription.messages_errors.please_choose')
      render 'my_subscription/choose_sub'
    end
  end
  # Author:
  #   Noha Hesham
  # Description:
  #   Allows the current developer to change his subscription model 
  #   and the limits are added to his my subscription
  # Success:
  #   The developer can change his subscription model successfully
  # Failure:
  #   None
  def pick_edit
    @all_subscription_models = SubscriptionModel.all
    @developer = Developer.find_by_gamer_id(current_gamer.id)
    sub_id = params[:my_subscription]
    dev_id = @developer.id
    if MySubscription.choose(dev_id, sub_id)
      flash[:success] = t(:sub_changed) 
      redirect_to '/gamers/edit'
    else
      flash[:notice] = I18n.t('controller.subscription.messages_errors.please_choose')
      render 'my_subscription/choose_sub'
    end
  end
end
