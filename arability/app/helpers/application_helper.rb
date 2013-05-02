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

  # Author:
  #   Mohamed Tamer
  # Description
  #   Finds guest_user object associated with the current session 
  #   and caches the value the first time it's gotten.
  # Params:
  #   guest_gamer_id: id of the guest gamer
  # Success: 
  #   Returns guest gamer
  # Failure:
  #   None
  def guest_gamer
    @cached_guest_gamer ||= Gamer.find(session[:guest_gamer_id])

  rescue ActiveRecord::RecordNotFound 
    session[:guest_gamer_id] = nil
    guest_gamer
  end
  
  # Author:
  #   Mohamed Tamer
  # Description
  #   Gets the current gamer currently on the sysytem either a signed in gamer or guest
  # Params:
  #   current_gamer: the currently logged in gamer
  # Success: 
  #   Returns current_gamer if there is a gamer signed in or guest_gamer
  # Failure:
  #   None
  def current_or_guest_gamer
    if current_gamer
      current_gamer
    else
      guest_gamer
    end
  end

end

