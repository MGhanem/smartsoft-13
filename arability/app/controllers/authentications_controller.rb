#encoding: UTF-8
class AuthenticationsController < ApplicationController
	
	def twitter
	end

	def twitter_callback
	  flash[:notice] = "Twitter تم الاتصال مع"
	  auth = request.env["omniauth.auth"]
      authentication = Authentication.find_by_provider_and_gid(auth["provider"], auth["gid"]) || Authentication.create_with_omniauth(auth)
	end

	def remove_twitter_connection
	  flash[:notice] = "Twitter تم إلغاء الاتصال مع"
	  Authentication.find_by_gamer_id_and_provider(current_gamer, "Twitter").destroy
	  render :action => "twitter"
	end

end
