class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    current_gamer.connect_to_facebook(request.env["omniauth.auth"])
    redirect_to "/gamers/edit", :flash => {success: t(:logged_in_to_fb)}
  end
  
end 