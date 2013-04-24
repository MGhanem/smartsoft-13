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
  #   Twitter callback with failure to connect to Twitter upon rejection or cancellation
  #   by the current_gamer himself or connection failure
  # params
  #   none
  # Success:
  #   redirect_to home page
  # Failure:
  #   none
	def twitter_failure
    flash[:notice] = I18n.t(:twitter_connection_failure)
	  redirect_to root_url
	end

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
          flash[:success] = "Signed in successfully via facebook"
          sign_in_and_redirect(:gamer, auth.gamer)
        else
          gamer = Gamer.find_by_email(email)
          if gamer
            # do not forget to change the function back when mirna changes her function
            Authentication.create_with_omniauth_amr(gamer.id,
              provider, gid, email, token, nil)
            flash[:success] = "Signed in successfully via facebook"
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
          flash: {success: "Your account is now connected to Facebook"}
        else
          redirect_to "/", flash: {notice: "You're signed in and your
            account is already connected to facebook"}
        end
      end
    else
      redirect_to "/", flash: {error: "Oops an error 
        has occured while communicating with Facebook. Please try again"}
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
    redirect_to "/", flash: {error: "Oops an error 
      has occured while communicating with Facebook. Please try again"}
  end

end
