class Gamers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Author:
  #   Salma Farag
  # Description:
  #   A  method that calls find_for_google_oauth2 from the gamer model and checks if he
  #   is signed up through his Google account.
  # Params:
  #   None
  # Success:
  #   Signs in the gamer and flashes a success notice.
  # Failure:
  #   Redirects to the ordinary sign in page and flashes a warning for the user to sign in from
  #   there.
  def google_oauth2
    @gamer = Gamer.find_for_google_oauth2(request.env["omniauth.auth"], current_gamer)
    if @gamer.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @gamer, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_gamer_session
      flash[:warning] = "The registered email cannot be logged in with Google, please sign in here."
    end
  end
end