module AdminHelper

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this method checks if the user is not admin and redirects him to arability home page
  # Params
  #   current_gamer
  # Success: 
  #   if the user is admin he is allowed into admin
  # Failure: 
  #   if the user is not admin he is redirect to arability home page and notified with error
  def authenticate_admin!
    unless current_gamer.try(:admin?)
      flash[:error] = "you are not authorized to view this page"
      redirect_to ""
    end
  end

end