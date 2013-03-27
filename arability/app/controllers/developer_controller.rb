class DeveloperController < ApplicationController
# author:
# 	Khloud Khalid
# description:
#  	generates view with form for registration as developer
# params:
#  	none
# success:
#  	view generated successfully
# failure:
# 	gamer not signed in  	
	def new
		if(gamer_signed_in?)
			@developer = Developer.new
		else
			flash[:notice] = "Please login to be able to register."
		end
	end
# author:
# 	Khloud Khalid
# description:
#  	creates new developer using parameters from registration form and renders my_subscription#new
# params:
#  	first_name, last_name
# success:
#  	developer created successfully
# failure:
# 	invalid information, user already registered as developer
	def create
		@developer = Developer.new(params[:developer])
		@developer.gamer_id = current_gamer.id
		if((Developer.find_by_gamer_id(current_gamer.id)) == nil)
			if @developer.save 
				render '/my_subscriptions/new'
			else
				flash[:notice] = "Failed to complete registration."
			end
		else
			#redirect to homepage
			flash[:notice] = "You are already registered as developer."
		end
	end
end
