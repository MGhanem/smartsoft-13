class GuestController < ApplicationController
  def sign_up
  end
  def signing_up
  	create_guest_gamer
  	redirect_to ("/game")
  end
end
