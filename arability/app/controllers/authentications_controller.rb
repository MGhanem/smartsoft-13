#encoding: UTF-8
class AuthenticationsController < ApplicationController
	
	def twitter
	end

	def twitter_callback
	  if I18n.locale==:en
	  	flash[:notice] = "Connected to Twitter successfully!"
	  else I18n.locale==:ar
	  	flash[:notice] = "تم التواصل مع تويتر بنجاح!"
	  end
	  auth = request.env["omniauth.auth"]
      authentication = Authentication.find_by_provider_and_gid(auth["provider"], current_gamer.id) || Authentication.create_with_omniauth(auth, current_gamer)
      redirect_to "/gamers/edit"
      return
	end

	def remove_twitter_connection
	  if I18n.locale==:en
	  	flash[:notice] = "Connection to Twitter removed successfully!"
	  else I18n.locale==:ar
	  	flash[:notice] = "تم إلغاء التواصل مع تويتر بنجاح!"
	  end
	  Authentication.remove_conn(current_gamer)
	  redirect_to "/gamers/edit"
	  return
	end

	def twitter_failure
	  if I18n.locale==:en
	  	flash[:notice] = "Failed to connect to Twitter"
	  else I18n.locale==:ar
	  	flash[:notice] = "فشل التواصل مع تويتر بنجاح"
	  end
	  redirect_to root_url
	end

end
