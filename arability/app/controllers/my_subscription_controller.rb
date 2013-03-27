class MySubscriptionController < ApplicationController
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
		if(gamer_signed_in?)
			@my_subscription = MySubscription.new
		else
			flash[:notice] = "Please login to proceed with registration."
		end	
	end
# author:
# 	Khloud Khalid
# description:
#  	creates new developer using parameters from registration form
# params:
#  	first_name, last_name
# success:
#  	developer created successfully
# failure:
# 	invalid information
	def create
		@subscription_model = params[:subscription_model]
		@my_subscription = MySubscription.new()
		@my_subscription.developer_id = current_developer.id
		@my_subscription.subscription_models_id = @subscription_model
		if @my_subscription.save 
			#redirect to home page
			flash[:notice] = "You have successfully registered as a developer."
		else
			flash[:notice] = "Failed to complete registration."
		end
	end

	
end
