module AdminHelper

  # author:
  #     Karim ElNaggar
  # description:
  #     checks if the user is logged in
  # params
  #     none
  # success: 
  #     returns true if the user is logged in as admin
  # failure: 
  #     none
  def logged_in?
    current_user == "admin"
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     current_user method
  # params
  #     none
  # success: 
  #     returns the session variable :who_is_this
  # failure: 
  #     none
  def current_user
    session[:who_is_this]
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     create session method
  # params
  #     none
  # success: 
  #     sets the session variable :who_is_this to "admin"
  # failure: 
  #     none
  def create_session
    session[:who_is_this] = "admin"
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     destroy_session method
  # params
  #     none
  # success: 
  #     unsets the session variable :who_is_this
  # failure: 
  #     none
  def destroy_session
    session[:who_is_this] = nil
  end
  
end
