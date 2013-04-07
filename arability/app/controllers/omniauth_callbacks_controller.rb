class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    Gamer.connect_to_facebook(current_gamer.id, request.env["omniauth.auth"])
    redirect_to controller: "authentications", action: "twitter"
  end
  
end 