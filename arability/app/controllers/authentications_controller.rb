#encoding: UTF-8
class AuthenticationsController < ApplicationController

  # Author:
  #   Mirna Yacout
  # Description:
  #   Twitter callback method which saves the parameters given by Twitter upon the approval of
  #   the current user for the connection
  # params
  #   the hash received from Twitter API including all his Twitter information
  # Success:
  #   checks if a record is in the Authentications table: if avaialable returns and redirect
  #   and if not creates a new record then redirect
  # Failure:
  #   none
	def twitter_callback
	  flash[:notice] = I18n.t(:add_twitter_connection)
	  auth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_gamer_id(auth["provider"],
     current_gamer.id) || Authentication.create_with_omniauth(auth["provider"], auth["uid"],
     auth["credentials"]["token"],auth["credentials"]["secret"], nil, current_gamer.id)
    redirect_to "/gamers/edit"
    return
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
	def remove_twitter_connection
    flash[:notice] = I18n.t(:remove_twitter_connection)
	  Authentication.remove_conn(current_gamer.id, "twitter")
	  redirect_to "/gamers/edit"
	  return
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
  #   Call back method envoked when facebook sends the hash back to
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
          flash[:success] = t(:signed_in_fb)
          sign_in_and_redirect(:gamer, auth.gamer)
        else
          gamer = Gamer.find_by_email(email)
          if gamer
            # do not forget to change the function back when mirna changes her function
            Authentication.create_with_omniauth_amr(gamer.id,
              provider, gid, email, token, nil)
            flash[:success] = t(:signed_in_fb)
            sign_in_and_redirect(:gamer, gamer)
          else
            session["devise.token"] = token
            session["devise.gid"] = gid
            session["devise.token_secret"] = nil
            redirect_to controller: "social_registrations",
            action: "new_social", email: email, username: username,
            gender: gender, provider: provider
          end
        end
      else
        if !auth
          # do not forget to change the function back when mirna changes her function
          Authentication.create_with_omniauth_amr(current_gamer.id,
            provider, gid, email, token, nil)
          redirect_to "/gamers/edit",
          flash: {success: t(:logged_in_to_fb)}
        else
          redirect_to "/", flash: {notice: t(:already_connected)}
        end
      end
    else
      redirect_to "/", flash: {error: t(:oops_error_fb)}
    end
  end

  # Author:
  #   Amr Abdelraouf
  # Description
  #   Function called by facebook when an error occurs
  # Params:
  #   none
  # Sucsess:
  #   Redirected to home page and error message is displayed
  # Failure:
  #   None
  def facebook_failure
    redirect_to "/", flash: {error: t(:oops_error_fb)}
  end

end
