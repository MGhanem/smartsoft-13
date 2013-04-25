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
  let(:authentication){
  	authentication = Authentication.new
  	authentication.gamer_id = current_gamer.id
    authentication.provider = "twitter"
    authentication.gid = "123456790"
    authentication.token = "1234567"
    authentication.token_secret = "asdfghj"
    authentication.save
    authentication
  }
	before do
		request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
	end
	it "should redirect to edit settings page if connecting to Twitter" do
		login_gamer(current_gamer)
		get :twitter_callback
		response.should redirect_to "/gamers/edit"
	end
	it "should remove twitter connection and redirect back to edit settings page" do
		login_gamer(current_gamer)
		get :remove_twitter_connection
		response.should redirect_to "/gamers/edit"
	end
	it "should redirect to home page upon failing to authorize the user" do
		login_gamer(current_gamer)
		get :callback_failure
		response.should redirect_to root_url
	end
	it "should sign in a gamer through his Twitter connection if available and redirect to home page" do
		authentication
		get :twitter_callback
		response.should redirect_to root_url
	end
	it "should redirect to sign up page if no authentication found" do
		get :twitter_callback
		expect(response).to render_template("twitter_signin")
	end
end