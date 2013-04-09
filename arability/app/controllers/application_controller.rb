class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from Exception, :with => :error_render_method

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def get_root
    if request.fullpath.match /\/^((ar|en)\/)?developers\//
      path = backend_home_path
    else
      path = root_path
    end
  end

  def routing_error
    path = get_root
    redirect_to path, flash: {error: "Sorry, we seem to have misplaced the page you were looking for \"#{params[:path]}\""}
  end

  def error_render_method(exception)
    path = get_root
    redirect_to path, 
      flash: {error: "Oops, this is embarassing. A problem has occured, however we have notified an administrator and are working to fix it"}
  end
end
