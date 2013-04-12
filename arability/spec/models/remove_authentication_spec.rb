#encoding: utf-8
require 'spec_helper'

describe "remove authentication to Twitter for current_gamer" do
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
    authentication.gid = "123"
    authentication.token = "1234567"
    authentication.token_secret = "asdfghj"
    authentication.save
    authentication
  }
  it "should remove authentication record from database for current_gamer" do
    k1 = Authentication.exists?(authentication.id)
    expect(k1).to eq(true)
  	Authentication.remove_conn(current_gamer)
    k2 = Authentication.exists?(authentication.id)
    expect(k2).to eq(false)
  end
end



