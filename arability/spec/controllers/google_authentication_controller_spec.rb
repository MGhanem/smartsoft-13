#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers

describe AuthenticationsController do

  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2] 
  end

  it "should redirect to the new_social page" do
    I18n.locale = :ar
    get :google_callback
    response.should redirect_to "/ar/social_registrations/new_social?" +
    "email=email%40mock.com&gender=male&provider=google_oauth2"
  end

  it "should redirect to home page, sign the user in and create an auth in his name" do
    g = Gamer.new
    g.username = "test"
    g.country = "Egypt"
    g.education_level = "school"
    g.gender = "male"
    g.date_of_birth = "1993-11-23"
    g.email = "email@mock.com"
    g.password = "123456"
    g.confirmed_at = Time.now
    g.save validate: false
    I18n.locale = :ar
    get :google_callback
    response.should redirect_to root_url
    expect(Authentication.exists?(gamer_id: g.id)).to eq(true)
  end

  it "should redirect to root url" do
    g = Gamer.new
    g.username = "test"
    g.country = "Egypt"
    g.education_level = "school"
    g.gender = "male"
    g.date_of_birth = "1993-11-23"
    g.email = "email@mock.com"
    g.password = "123456"
    g.confirmed_at = Time.now
    g.save validate: false
    Authentication.create_with_omniauth(
      "google",
       "011252217", 
       "mock123token456", 
       nil, 
       "email@mock.com", 
       g.id)
    I18n.locale = :ar
    get :google_callback
    response.should redirect_to root_url
  end

end