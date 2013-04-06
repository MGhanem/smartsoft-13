module AdminHelper
  def is_logged_in?
    session["who_is_this"] == "admin"
  end
end
