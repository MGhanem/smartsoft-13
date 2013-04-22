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
    gamer.save validate: false
    login(gamer)
    gamer
  end

  def create_logged_in_developer
    gamer = create_logged_in_user
    dev = Developer.new
    dev.first_name = "test"
    dev.last_name = "test"
    dev.gamer_id = gamer.id
    dev.save
    dev
  end

  def login(gamer)
    login_as gamer, scope: :gamer
  end
  
  def login_gamer(u)
    @request.env["devise.mapping"] = Devise.mappings[:gamer]
    sign_in u
  end
 end
