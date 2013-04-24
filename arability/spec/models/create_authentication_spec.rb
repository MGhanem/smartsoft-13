#encoding: utf-8
require 'spec_helper'

describe "create authentication to Twitter for current_gamer" do
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
  it "should create a new record for Twitter authentication in database for current_gamer" do
    auth =
      {"provider" => "twitter",
       "uid"      => "1234",
       "info"   => {"name"       => "John Doe",
                    "email"      => "johndoe@email.com"},
       "credentials" => {"token" => "testtoken234tsdf",
                        "secret" => "tokensecrettest"}}
    k1 = Authentication.exists?(gamer_id: current_gamer.id)
    expect(k1).to eq(false)
    record = Authentication.create_with_omniauth(auth["provider"],
    auth["uid"], auth["credentials"]["token"], auth["credentials"]["secret"], nil, current_gamer.id)
    k2 = Authentication.exists?(record.id)
    expect(k2).to eq(true)
  end
end