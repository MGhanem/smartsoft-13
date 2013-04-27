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
	def remove_connection
    flash[:notice] = I18n.t(:remove_twitter_connection)
	  Authentication.remove_conn(current_gamer.id, params[:provider])
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

end
