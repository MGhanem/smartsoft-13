#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers

describe SocialRegistrationsController do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:gamer]
  end

  it "should create a new gamer, create an authentication for that gamer and redirect to root url" do
    post :social_sign_in, gamer: {
      email: "email@mock.com",
      username: "mockimock",
      gender: "male",
      "date_of_birth(1i)" => "1993",
      "date_of_birth(2i)" => "11",
      "date_of_birth(3i)" => "23",
      country: "Egypt",
      education_level: "School",
      gid: "011252217",
      provider: "facebook",
      token: "mock123token456",
      token_secret: nil,
      social_email: "email@mock.com"}
    expect(Gamer.exists?(email: "email@mock.com")).to eq(true)
    expect(Authentication.exists?(gid: "011252217", provider: "facebook")).to eq(true)
    response.should redirect_to root_url
  end

end