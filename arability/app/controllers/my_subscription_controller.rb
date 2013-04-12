class MySubscriptionController < ApplicationController
  before_filter :authenticate_gamer!
  #before_filter :prepare_subscriptions, :only => [:choose_sub, :pick]

  def choose_sub
    @all_subscription_models = SubscriptionModel.all
    @developer = Developer.find_by_gamer_id(current_gamer.id)
    # @developer = Developer.first#for testing
  end

  def pick
    @all_subscription_models = SubscriptionModel.all
    @developer = Developer.find_by_gamer_id(current_gamer.id)
    # @developer = Developer.first#for testing
    sub_id = params[:my_subscription]
    dev_id = @developer.id
  
    if MySubscription.choose(dev_id,sub_id)
      flash[:notice] = "You have successfully chosen your subscription model"
        redirect_to root_url
    else
      flash[:notice] = "Please choose your subscription model"
      render 'my_subscription/choose_sub'
    end
  end
end
