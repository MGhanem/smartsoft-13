class SocialController < ApplicationController

	def connect_to_twitter
		flash[:notice] = "button pressed"
	end

end
