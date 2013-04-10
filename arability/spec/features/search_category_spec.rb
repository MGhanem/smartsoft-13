require 'spec_helper'

describe SearchController do
  include Warden::Test::Helpers
  let(:gamer) { gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level="high"
    gamer.gender = "male"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "test@test.com"
    gamer.password = "testing"
    gamer.save
    gamer
  }
  it "should filter keywords serched by category" do
    login_as gamer
    visit "/developers/search_keywords"
    fill_in "search", with: "test"
    click_on "search_button"
  end
end
