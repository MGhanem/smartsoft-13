module AdminHelper

  # author:
  #     Karim ElNaggar
  # description:
  #     this method checks if the user is not admin and redirects him to arability home page
  # params
  #    current_gamer
  # success: 
  #     if the user is admin he is allowed into admin
  # failure: 
  #     if the user is not admin he is redirect to arability home page and notified with error
  def authenticate_admin!
    unless current_gamer.try(:admin?)
      flash[:error] = "you are not authorized to view this page"
      redirect_to ""
    end
  end

end