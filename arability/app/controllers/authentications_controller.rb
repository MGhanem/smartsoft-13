#encoding: UTF-8
class AuthenticationsController < ApplicationController

	# Author:
    #  Mirna Yacout
    # Description:
    #  checks if the current_gamer already has an Authentication record
    # params
    #  none
    # Success:
    #  displays the correct view depending on the availability of Twitter authentication record
    #  in the Authentications table
    # Failure:
    #  none
	def twitter
	end

	# Author:
    #  Mirna Yacout
    # Description:
    #  Twitter callback method which saves the parameters given by Twitter upon the approval of
    #  the current user for the connection
    # params
    #     none
    # Success:
    #  checks if a record is in the Authentications table: if avaialable returns and redirect
    #  and if not creates a new record then redirect
    # Failure:
    #  none
	def twitter_callback
	  if I18n.locale == :en
	  	flash[:notice] = "Connected to Twitter successfully!"
	  else I18n.locale == :ar
	  	flash[:notice] = "تم التواصل مع تويتر بنجاح!"
	  end
	  auth = request.env["omniauth.auth"]
      authentication = Authentication.find_by_provider_and_gid(auth["provider"],
       current_gamer.id) || Authentication.create_with_omniauth(auth,
        current_gamer)
      redirect_to "/gamers/edit"
      return
	end

	# Author:
    #  Mirna Yacout
    # Description:
    #  removes connection already in the table
    # params
    #     none
    # Success:
    #  finds connection record, removes it correctly and redirect
    # Failure:
    #  doesnot find the record
	def remove_twitter_connection
	  if I18n.locale == :en
	  	flash[:notice] = "Connection to Twitter removed successfully!"
	  else I18n.locale == :ar
	  	flash[:notice] = "تم إلغاء التواصل مع تويتر بنجاح!"
	  end
	  Authentication.remove_conn(current_gamer)
	  redirect_to "/gamers/edit"
	  return
	end

	# Author:
    #  Mirna Yacout
    # Description:
    #  Twitter callback with failure to connect to Twitter upon rejection or cancellation
    #  by the current_gamer himself or connection failure
    # params
    #  none
    # Success:
    #  redirect_to home page
    # Failure:
    #  none
	def twitter_failure
	  if I18n.locale == :en
	  	flash[:notice] = "Failed to connect to Twitter"
	  else I18n.locale == :ar
	  	flash[:notice] = "فشل التواصل مع تويتر بنجاح"
	  end
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