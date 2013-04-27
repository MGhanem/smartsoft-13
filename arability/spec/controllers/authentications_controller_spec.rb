#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers

describe AuthenticationsController do
	let(:current_gamer){
    current_gamer = Gamer.new
    current_gamer.username = "Test"
    current_gamer.country = "Egypt"
    current_gamer.education_level = "high"
    current_gamer.gender = "female"
    current_gamer.date_of_birth = 1993-03-23
    current_gamer.email = "test@gmail.com"
    current_gamer.password = "1234567"
    current_gamer.save validate: false
    current_gamer
  }
	before do
		request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
	end
	it "should redirect to edit settings page" do
		login_gamer(current_gamer)
		get :twitter_callback
		response.should redirect_to "/gamers/edit"
	end
	it "should remove twitter connection" do
		login_gamer(current_gamer)
		get :remove_twitter_connection
		response.should redirect_to "/gamers/edit"
	end
	it "it should redirect to home page" do
		login_gamer(current_gamer)
		get :callback_failure
		response.should redirect_to root_url
	end
end