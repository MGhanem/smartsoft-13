class DeveloperController < ApplicationController
  def index
  	
  end

  
    #Shall be placed in it's proper controller
    # def check_for_search_permission
    #   if(current_user.my_subscription.limit_search == 0)
    #     render :text => "Limit reached", :status => 422
    #   else
    #     render :text => "", :status => 200
    #   end
    # end

    # def decrement_search
    #   current_user.my_subscription.decrement_limit(:limit_search)
    #   render :text => current_user.my_subscription.limit_search.to_s
    # end

    

  
end
