# spec/support/request_helpers.rb
require 'spec_helper'
include Warden::Test::Helpers

module RequestHelpers
  def create_logged_in_user
    gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level="high"
    gamer.gender = "male"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "test@test.com"
    gamer.password = "testing"
    gamer.save
    login(gamer)
    gamer
  end

  def login(gamer)
    sign_in(gamer, :scope => :gamer)
  end
end
