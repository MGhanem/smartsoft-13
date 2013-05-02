#encoding: UTF-8
require 'spec_helper'

describe "tests facebook and token related functions in authentication model" do

  let(:auth){
    authentication = Authentication.new
    authentication.gamer_id = 25
    authentication.gid = "123456"
    authentication.provider = "facebook"
    authentication.token = "mock123token456"
    authentication.token_secret = nil
    authentication.email = "mock@email.com"
    authentication.save validate: false
    authentication
  }

  it "should return true since the gamer with id 25 is connected to facebook" do
    auth
    is_connected = Authentication.is_connected_to_facebook(25)
    expect(is_connected).to eq(true)
  end

  it "should return false since the gamer with id 2 is not connected to facebook" do
    auth
    is_connected = Authentication.is_connected_to_facebook(2)
    expect(is_connected).to eq(false)
  end

  it "should return a value equal to the token in :auth" do
    auth
    token = Authentication.get_token(25, "facebook")
    expect(token).to eq("mock123token456")
  end

  it "should return the new token when function get_token is called" do
    old_token = auth.token
    Authentication.update_token(25, "facebook", "NewMockToken123")
    new_token = Authentication.get_token(25, "facebook")
    expect(old_token).to eq("mock123token456")
    expect(new_token).to eq("NewMockToken123")
  end

end