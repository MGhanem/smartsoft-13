#encoding: utf-8
require 'spec_helper'

describe "retrieve list of friends who are also gamers" do
  let(:current_gamer){
    current_gamer = Gamer.new
    current_gamer.id = 1
    current_gamer.username = "Test"
    current_gamer.country = "Egypt"
    current_gamer.education_level = "high"
    current_gamer.gender = "female"
    current_gamer.date_of_birth = 1993-03-23
    current_gamer.email = "test@gmail.com"
    current_gamer.password = "1234567"
    current_gamer.save
    current_gamer
  }

  let(:tauthentication){
    authentication = Authentication.new
  	authentication.gamer_id = current_gamer.id
    authentication.provider = "twitter"
    authentication.gid = "1033328257"
    authentication.token = "1234567"
    authentication.token_secret = "asdfghj"
    authentication.save
    authentication
  }

  let(:fbauthentication){
    authentication = Authentication.new
    authentication.gamer_id = current_gamer.id
    authentication.provider = "facebook"
    authentication.gid = "1033328257"
    authentication.token = "1234567"
    authentication.token_secret = "asdfghj"
    authentication.save
    authentication
  }

  it "should return nil if no authentication is found for twitter" do
    auth = Authentication.find_by_gamer_id_and_provider(current_gamer.id, "twitter")
    expect(auth).to eq(nil)
    result = Authentication.get_common_twitter_friends(current_gamer)
    expect(result).to eq(nil)
  end

  it "should return false if no internet connection was found for twitter" do
    current_gamer
    tauthentication
    JSON.stub(:parse) { raise SocketError }
    Authentication.get_common_twitter_friends(current_gamer).should be_false
  end

  it "should retrieve list of twitter friends" do
    current_gamer
    tauthentication
    result = Authentication.get_common_twitter_friends(current_gamer)
    expect(result).to eq([1])
  end

  it "should return nil if no authentication is found for facebook" do
    auth = Authentication.find_by_gamer_id_and_provider(current_gamer.id, "facebook")
    expect(auth).to eq(nil)
    result = Authentication.get_common_facebook_friends(current_gamer)
    expect(result).to eq(nil)
  end
  
end