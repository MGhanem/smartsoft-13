#encoding: UTF-8
class AuthenticationsController < ApplicationController
	
	def twitter
	end

	def twitter_callback
	  auth = request.env["omniauth.auth"]
      authentication = Authentication.find_by_provider_and_gid(auth["provider"], current_gamer.id) || Authentication.create_with_omniauth(auth, current_gamer)
	end

	def remove_twitter_connection
	  Authentication.remove_conn(current_gamer)
	  render :action => "twitter"
	end

	def twitter_hall_of_fame
		if Authentication.get_common_twitter_followers(current_gamer).nil?
		  if I18n.locale==:en
	  	    flash[:notice] = "You've not connected your account to twitter"
	  	  else I18n.locale==:ar
	  	    flash[:notice] = "لم يتم التواصل بتويتر"
	  	  end
		  render :action => "twitter"
		  return
		end
	end

end
