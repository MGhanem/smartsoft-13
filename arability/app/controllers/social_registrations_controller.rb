class SocialRegistrationsController < Devise::RegistrationsController

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Loads custom sign up page where the text boxes are filled with
  #   the data received by the method
  # Params:
  #   email: user email
  #   username: user username
  #   gender: user gender
  #   provider: the provider of the API
  #   errors: an array containing the error messages which didn't
  #   allow the user to sign up in the first place
  # Success:
  #   User signs up, is redirected to his homepage and an Authentication
  #   linked to his account is created
  # Failure:
  #   User inputs invalid data, is redirected to the same sign up page
  #   and the error messages are displayed
  def new_social
    @email = params[:email]
    @username = params[:username]
    @gender = params[:gender]
    @provider = params[:provider]
    @gid = session["devise.gid"]
    @token = session["devise.token"]
    @token_secret = session["devise.token_secret"]
    @errors = params[:errors]
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Invoked when a guest signs up with an existing account.
  #   The gamer is created with the input values and then an authentication
  #   is created to link his social media account to that local account
  # Params:
  #   Post parameters
  #   email: user email
  #   username: user username
  #   gender: user gender
  #   date_of_birth(1i): user year of birth
  #   date_of_birth(2i): user month of birth
  #   date_of_birth(3i): user day of birth
  #   country: user country
  #   ed_level: user education level
  #   gid: user uid provided by API hash
  #   provider: the provider of the API
  #   token: user access token
  #   token_secret: user token_secret
  #   social_email: the email returned by the API
  # Success:
  #   Gamer is created and an Authentcation is created linked
  #   to that gamer
  # Failure:
  #   Entered data is invalid and the user is redirected back
  #   to new_social.html.erb with error messages displayed
  def social_sign_in
    email = params[:gamer][:email]
    username = params[:gamer][:username]
    gender = params[:gamer][:gender]
    year = params[:gamer]["date_of_birth(1i)"].to_i
    month = params[:gamer]["date_of_birth(2i)"].to_i
    day = params[:gamer]["date_of_birth(3i)"].to_i
    d_o_b = Date.new(year, month, day)
    d_o_b.to_datetime
    country = params[:gamer][:country]
    ed_level = params[:gamer][:education_level]
    gid = params[:gamer][:gid]
    provider = params[:gamer][:provider]
    token = params[:gamer][:token]
    token_secret = params[:gamer][:token_secret]
    social_email = params[:gamer][:social_email]
    gamer, is_saved = Gamer.create_with_social_account(
      email, username, gender, d_o_b, country, ed_level, provider)
    if is_saved
      if token != ""
        Authentication.create_with_omniauth(
          provider, gid, token, token_secret, social_email, gamer.id)
        session["devise.token"] = nil
        session["devise.gid"] = nil
        session["devise.token_secret"] = nil
      end
      flash[:success] = t(:signed_in_exst)
      sign_in_and_redirect(:gamer, gamer)
    else
      session["devise.token"] = token
      session["devise.gid"] = gid
      session["devise.token_secret"] = token_secret
      redirect_to controller: "social_registrations",
      action: "new_social", email: email, username: username,
      gender: gender, provider: provider, errors: gamer.errors.full_messages
    end
  end

end