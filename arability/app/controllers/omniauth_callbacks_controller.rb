class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    Gamer.connect_to_facebook(current_gamer.id, request.env["omniauth.auth"])
    redirect_to "/gamers/edit", :flash => {success: "CONGARTULATIONS!! Your Facebook account was successfully linked!"}
  end
  
end 