class MySubscriptionController < ApplicationController
  before_filter :authenticate_gamer!
  #before_filter :prepare_subscriptions, :only => [:choose_sub, :pick]
  
  # Author:
  #  Noha Hesham
  # Description:
  #  gets all the subscription models available and finds the the current 
  #  developer by the gamer id
  # Params:
  #  none
  # success:
  #  all subscription models are listed
  # Failure:
  #  subscription models are not listed

  def choose_sub
    @all_subscription_models = SubscriptionModel.all
    @developer = Developer.find_by_gamer_id(current_gamer.id)
  end

  # Author:
  #  Noha Hesham
  # Description:
  #  allows the current developer to choose his subscription model 
  #  and the limits are added to his my subscription
  # success:
  #  the developer can choose his subscription model successfully
  # Failure:
  #  payment issues

  def pick
    @all_subscription_models = SubscriptionModel.all
    @developer = Developer.find_by_gamer_id(current_gamer.id)
    sub_id = params[:my_subscription]
    dev_id = @developer.id
    if MySubscription.choose(dev_id,sub_id)
      flash[:notice] = I18n.t('controller.subscription.messages_errors.you_have_successfully_chosen_your_model')
      redirect_to projects_path
    else
      flash[:notice] = I18n.t('controller.subscription.messages_errors.please_choose')
      render 'my_subscription/choose_sub'
    end
  end
end
