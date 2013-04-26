#encoding: utf-8
require 'spec_helper'
include Warden::Test::Helpers

describe "retrieve list of followers who are also gamers" do
  include Devise::TestHelpers
  let(:current_gamer){
    current_gamer = Gamer.new
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
  let(:authentication){
    authentication = Authentication.new
  	authentication.gamer_id = current_gamer.id
    authentication.provider = "twitter"
    authentication.gid = "1033328257"
    authentication.token = "1234567"
    authentication.token_secret = "asdfghj"
    authentication.save
    authentication
  }
  let(:follower){
    current_gamer = Gamer.new
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
  let(:other_authentication){
    authentication = Authentication.new
    authentication.gamer_id = follower.id
    authentication.provider = "twitter"
    authentication.gid = "1320539406"
    authentication.token = "1234567"
    authentication.token_secret = "asdfghj"
    authentication.save
    authentication
  }
  it "should retrieve list of common followers" do
    sign_in current_gamer
    result = Authentication.get_common_twitter_followers(current_gamer)
    expect(result).to eq(["1320539406", "1033328257"])
  end
end



