  # spec/support/request_helpers.rb
require 'spec_helper'
include Warden::Test::Helpers

module RequestHelpers
  def create_logged_in_user
    gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level="high"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "test@test.com"
    gamer.password = "testing"
    gamer.confirmed_at = Time.now
    gamer.save validate: false
    login_gamer(gamer)
    gamer
  end

  def create_logged_in_developer
    gamer = create_logged_in_user
    dev = Developer.new
    dev.gamer_id = gamer.id
    dev.save validate:false
    dev
  end

  def login(gamer)
    login_as gamer, scope: :gamer
  end

  def login_gamer(u)
    @request.env["devise.mapping"] = Devise.mappings[:gamer]
    sign_in u
  end

  def create_project
    d = create_logged_in_developer()
    project = Project.new
    project.name = "banking"
    project.minAge = 19
    project.maxAge = 25
    project.owner_id = d.id
    project.save
    project
  end
end
