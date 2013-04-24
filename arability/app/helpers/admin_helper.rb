module AdminHelper
  def authenticate_admin!
    unless current_gamer.try(:admin?)
      flash[:error] = "you are not authorized to view this page"
      redirect_to ""
    end
  end
end
