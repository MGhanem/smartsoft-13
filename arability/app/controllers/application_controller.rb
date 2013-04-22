class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  # Author:
  #   Mohamed Ashraf
  # Desciption:
  #   This function sets the locale to the default locale of ar or the
  #   whichever locale stored in the session. If a locale is chosen it is
  #   automatically stored in the session.
  # params:
  #   locale: from the url if exists
  # success:
  #   sets the current locale for all views
  # failure:
  #   --
  def set_locale
    if params[:locale].nil?
      I18n.locale = session[:locale].nil? ? :ar : session[:locale]
    else
      I18n.locale = params[:locale]
      session[:locale] = params[:locale]
    end
  end

  # Author:
  #   Mohamed Ashraf
  # Description:
  #   It adds the current locale to the url if not specified
  # params:
  #   locale: from the url if exists
  # success:
  #   adds current locale to the urls if not specified
  # failure:
  #   --
  def default_url_options(options={})
    { locale: I18n.locale }
  end
end
