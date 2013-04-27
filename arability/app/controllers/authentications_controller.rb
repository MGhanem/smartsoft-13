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
