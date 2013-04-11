require "spec_helper"
include Warden::Test::Helpers

describe "gamer sign in" do
  let(:gamer) {
    gamer = Gamer.new
    gamer.username = "adamggg"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "male"
    gamer.date_of_birth = "1992-04-18"
    gamer.email = "no...@gmail.com"
  }
  
  it "sign in gamer succesffuly" do
    login_as gamer
  end

  
end

