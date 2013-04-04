class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new(155521981280754, a4d4684f0554e3637085e72eaa132890).get_user_info_from_cookie(cookies)
  end



end
