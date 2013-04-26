module ApplicationHelper
  
  # USAGE:
  # To include any of these helper methods in your controllers make 
  # sure you write "include ApplicationHelper" at the top of the file

  # Checks if current signed in gamer has a developer account
  # author:
  #   Adam Ghanem, Salma Farag
  # params:
  #   none
  # returns:
  #   true if the gamer has a developer account otherwise false
  def developer_signed_in?
    Developer.find_by_gamer_id(current_gamer.id) != nil
  end

  # returns the actual developer instance that is currently logged in
  # author:
  #   Adam Ghanem
  # params:
  #   none
  # returns:
  #   success: returns the current developer that is signed in
  #   failure: returns nil
  def current_developer
    Developer.find_by_gamer_id(current_gamer.id)
  end

  def developer_unauthorized
    flash.now[:error] = "You are not authorized to view this page" 
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_gamer
    # Cache the value the first time it's gotten.
    @cached_guest_gamer ||= Gamer.find(session[:guest_gamer_id])

  rescue ActiveRecord::RecordNotFound # if session[:guest_gamer_id] invalid
     session[:guest_gamer_id] = nil
     guest_gamer
  end
  
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_gamer
    if current_gamer
      current_gamer
    else
      guest_gamer
    end
  end

end

