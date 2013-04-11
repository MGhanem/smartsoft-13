class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	# Author:
  #   Amr Abdelraouf
  # Description:
  #   The omniauth call back method. Whena user 
  # Params:
  #   None
  # Success:
  #   The user's facebook data will be deleted and a flash notice will appear
  #   to ensure the user that he's disconnected
  # Failure:
  #   None
  def facebook
  	if current_gamer.is_connected_to_facebook
  	  current_gamer.update_access_token(request.env["omniauth.auth"])
  	  redirect_to controller: 'games', action: 'post'
  	else
      current_gamer.connect_to_facebook(request.env["omniauth.auth"])
      redirect_to "/gamers/edit", :flash => {success: t(:logged_in_to_fb)}
    end
  end
  
end 