#encoding: UTF-8
class AuthenticationsController < ApplicationController

  # Author:
  #   Mirna Yacout
  # Description:
  #   Twitter callback method which creates new authentication for signed in gamer connecting
  #   to his Twitter account or signs in a guest with his Twitter account
  # params
  #   the hash received from Twitter API including all his Twitter information
  # Success:
  #   if gamer is signed in then create a new Authentication (unless it already exists) and
  #   redirects to edit settings page,
  #   else a guest signing in using his Twitter account: if Authentication exists sign in gamer
  #   connected to Authentication and redirect to home page
  #   if not rediect to complete sign up page to fill missing information
  # Failure:
  #   none
	def twitter_callback
	  auth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_gid(auth["provider"],
     auth["uid"])
    if gamer_signed_in?
      if authentication.nil?
        flash[:notice] = I18n.t(:add_twitter_connection)
        Authentication.create_with_omniauth(auth["provider"], auth["uid"],
         auth["credentials"]["token"],auth["credentials"]["secret"], nil,
          current_gamer.id)
      else
        flash[:error] = I18n.t(:connected_before)
      end
      redirect_to "/gamers/edit"
      return
    else
      if authentication
        flash[:notice] = I18n.t(:twitter_signin_success)
        gamer = Gamer.find(authentication.gamer_id)
        sign_in_and_redirect(:gamer, gamer)
      else
        session["devise.token"] = auth["credentials"]["token"]
        session["devise.gid"] = auth["uid"]
        session["devise.token_secret"] = auth["credentials"]["secret"]
        redirect_to controller: "social_registrations",
        action: "new_social", username: auth["info"]["nickname"],
        provider: auth["provider"]
      end
    end
	end

  # Author:
  #   Mirna Yacout
  # Description:
  #   removes connection already in the table
  # params
  #   none
  # Success:
  #   finds connection record, removes it correctly and redirect
  # Failure:
  #   doesnot find the record
	def remove_connection
    flash[:notice] = I18n.t(:remove_social_connection)
	  Authentication.remove_conn(current_gamer.id, params[:provider])
	  redirect_to "/gamers/edit"
	end

  # Author:
  #   Mirna Yacout
  # Description:
  #   Callback with failure to connect to Provider upon rejection or cancellation
  #   by the current_gamer himself or connection failure
  # params
  #   none
  # Success:
  #   redirect_to home page
  # Failure:
  #   none
	def callback_failure
    flash[:error] = I18n.t(:connection_failure)
	  redirect_to root_url
	end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Call back method invoked when facebook sends the hash back to
  #   Arability. This method is quite a handful. If the hash is empty
  #   an error message is displayed. If the gamer is already signed in it
  #   indicates that the user wants to connect his account rather than sign
  #   in. If so an Authentication is connected which links his account to
  #   Facebook. If he is not signed in we check whether there is an
  #   authentication linking this facebook hash to a local account.
  #   If yes we sign in that account. If not we check whether there
  #   is a gamer account with the same email. If yes we sign in that gamer
  #   and create an authentication linking this hash to that gamer account
  #   if not we redirect to a filled in sign up page
  # Params:
  #   Hash returned by facebook API
  # Success:
  #   Signed in or redirected to a filled in sign up page
  # Failure:
  #   Hash is empty (API error) or the account is logged in AND already
  #   connected to facebook. In both cases the user is redirected to the
  #   home page and an error message is displayed.
  def facebook_callback
    hash = request.env["omniauth.auth"]
    if hash
      email = hash["info"]["email"]
      username = hash["info"]["nickname"]
      gender = hash["extra"]["raw_info"]["gender"]
      provider = hash["provider"]
      gid = hash["uid"]
      token = hash["credentials"]["token"]
      auth = Authentication.find_by_provider_and_gid(provider, gid)
      if !gamer_signed_in?
        if auth
          if auth.gamer
            flash[:success] = t(:signed_in_fb)
            sign_in_and_redirect(:gamer, auth.gamer)
          else
            flash[:error] = t(:no_account)
            redirect_to "/gamers/sign_up"
          end
        else
          gamer = Gamer.find_by_email(email)
          if gamer
            Authentication.create_with_omniauth(provider,gid,
              token, nil, email, gamer.id)
            flash[:success] = t(:signed_in_fb)
            sign_in_and_redirect(:gamer, gamer)
          else
            session["devise.token"] = token
            session["devise.gid"] = gid
            session["devise.token_secret"] = nil
            flash[:info] = t(:continue_reg_fb)
            redirect_to controller: "social_registrations",
            action: "new_social", email: email, username: username,
            gender: gender, provider: provider
          end
        end
      else
        if !auth
          Authentication.create_with_omniauth(provider,gid,
            token, nil, email, current_gamer.id)
          flash[:success] = t(:logged_in_to_fb)
          redirect_to "/gamers/edit"
        else
          Authentication.update_token(current_gamer.id, provider, token)
          redirect_to "/games/post_facebook"
        end
      end
    else
      flash[:error] = t(:oops_error_fb)
      redirect_to root_url
    end
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   Call back method invoked when google sends the hash back to
  #   Arability. This method is quite a handful. If the hash is empty
  #   an error message is displayed. If the gamer is already signed in it
  #   indicates that the user wants to connect his account rather than sign
  #   in. If so an Authentication is connected which links his account to
  #   Google. If he is not signed in we check whether there is an
  #   authentication linking this Google hash to a local account.
  #   If yes we sign in that account. If not we check whether there
  #   is a gamer account with the same email. If yes we sign in that gamer
  #   and create an authentication linking this hash to that gamer account
  #   if not we redirect to a filled in sign up page
  # Params:
  #   Hash returned by google API
  # Success:
  #   Signed in or redirected to a filled in sign up page
  # Failure:
  #   Hash is empty (API error) or the account is logged in AND already
  #   connected to google. In both cases the user is redirected to the
  #   home page and an error message is displayed.
  def google_callback
    hash = request.env["omniauth.auth"]
    if hash
      email = hash["info"]["email"]
      split_email = email.split("@")
      username = split_email[0]
      gender = hash["extra"]["raw_info"]["gender"]
      provider = hash["provider"]
      gid = hash["uid"]
      token = hash["credentials"]["token"]
      refresh_token = hash["credentials"]["refresh_token"]
      auth = Authentication.find_by_provider_and_gid(provider, gid)
      if !gamer_signed_in?
        if auth
          if auth.gamer
            flash[:success] = t(:signed_in_google)
            sign_in_and_redirect(:gamer, auth.gamer)
          else
            flash[:error] = t(:no_account)
            redirect_to "/gamers/sign_up"
          end
        else
          gamer = Gamer.find_by_email(email)
          if gamer
            Authentication.create_with_omniauth(provider,gid,
              token, refresh_token, email, gamer.id)
            flash[:success] = t(:signed_in_google)
            sign_in_and_redirect(:gamer, gamer)
          else
            session["devise.token"] = token
            session["devise.gid"] = gid
            session["devise.token_secret"] = refresh_token
            flash[:info] = t(:continue_reg_google)
            redirect_to controller: "social_registrations",
            action: "new_social", email: email, username: username,
            gender: gender, provider: provider
          end
        end
      else
        flash[:error] = t(:connected_to_google)
        redirect_to root_url
      end
    else
      flash[:error] = t(:oops_error_google)
      redirect_to root_url
    end
  end

end
