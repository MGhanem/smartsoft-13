class MySubscriptionController < ApplicationController
	before_filter :authenticate_gamer!
# author:
# 	Khloud Khalid
# description:
#  	generates view with form for choosing subscription model
# params:
#  	none
# success:
#  	view generated successfully
# failure:
# 	gamer not signed in  
	def new
			@my_subscription = MySubscription.new
	end
# author:
# 	Khloud Khalid
# description:
#  	creates new my_subscription using parameters from registration form and links it to the developer
# params:
#  	subscription_model_id
# success:
#  	my_subscription created successfully and linked to developer
# failure:
# 	invalid information
	def create
		@my_subscription = MySubscription.new()
		@my_subscription.developer_id = Developer.find_by_gamer_id(current_gamer.id).id
		@my_subscription.subscription_models_id = params[:my_subscription]
		if @my_subscription.save 
			flash[:notice] = "You have successfully registered as a developer."
			render 'my_subscription/new'
		else
			flash[:notice] = "Failed to complete registration."
			render 'my_subscription/new'
		end
	end

	
end
