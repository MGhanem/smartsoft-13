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
	  auth = request.env["omniauth.auth"]
    if gamer_signed_in?
      flash[:notice] = I18n.t(:add_twitter_connection)
      authentication = Authentication.find_by_provider_and_gamer_id(auth["provider"],
       current_gamer.id) || Authentication.create_with_omniauth(auth["provider"], auth["uid"],
       auth["credentials"]["token"],auth["credentials"]["secret"], nil, current_gamer.id)
      redirect_to "/gamers/edit"
      return
    else
      authentication = Authentication.find_by_provider_and_gid(auth["provider"], auth["uid"])
      if authentication
        flash[:notice] = I18n.t(:twitter_signin_success)
        gamer = Gamer.find(authentication.gamer_id)
        sign_in_and_redirect(:gamer, gamer)
      else
        render "twitter_signin"
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

end
