module GuestHelper
	def resource_name
    :gamer
  end

  def resource
    @resource ||= Gamer.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:gamer]
  end
end
