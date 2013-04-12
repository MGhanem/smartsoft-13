class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  # Desciption:
  #   This function sets the locale to the default locale of ar or the
  #   whichever locale stored in the session. If a locale is chosen it is
  #   automatically stored in the session.
  # Author:
  #   Mohamed Ashraf
  # params:
  #   locale: from the url if exists
  # returns:
  #   --
  def set_locale
    if params[:locale].nil?
      if session[:locale].nil?
        I18n.locale = :ar
      else
        I18n.locale = session[:locale]
      end
    else
      I18n.locale = params[:locale]
      session[:locale] = params[:locale]
    end
  end

  # Description:
  #   It adds the current locale to th url  if not specified so that pages
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
end
