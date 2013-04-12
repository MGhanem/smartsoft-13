#encoding: UTF-8
require 'spec_helper'

describe "Tests gamer functions whcih are related to facebook" do

	let(:gamer) {
    gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level = "School"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "no@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
  }

  let(:connected_gamer) {
    gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level = "School"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "no@gmail.com"
    gamer.password = "1234567"
    gamer.provider = "facebook"
    gamer.uid = "123456"
    gamer.token = "RogueTokenString1234abcdefghijklmnopqrstuvwxyz"
    gamer.save
    gamer
  }

  let(:auth) {
    a = {
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :nickname => 'jbloggs',
          :email => 'joe@bloggs.com',
          :name => 'Joe Bloggs',
          :first_name => 'Joe',
          :last_name => 'Bloggs',
          :image => 'http://graph.facebook.com/1234567/picture?type=square',
          :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
          :location => 'Palo Alto, California',
          :verified => true
        },
        :credentials => {
          :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
          :expires_at => 1321747205, # when the access token expires (it always will)
          :expires => true # this will always be true
        },
        :extra => {
          :raw_info => {
            :id => '1234567',
            :name => 'Joe Bloggs',
            :first_name => 'Joe',
            :last_name => 'Bloggs',
            :link => 'http://www.facebook.com/jbloggs',
            :username => 'jbloggs',
            :location => { :id => '123456789', :name => 'Palo Alto, California' },
            :gender => 'male',
            :email => 'joe@bloggs.com',
            :timezone => -8,
            :locale => 'en_US',
            :verified => true,
            :updated_time => '2011-11-11T06:21:03+0000'
          }
        }
      }
      a
  }

#  it "saves provider, uid and token in database when called by facebook" do
#    gamer.connect_to_facebook(auth)
#    has_uid = !gamer.uid.nil?
#    has_provider = !gamer.provider.nil?
#    has_token = !gamer.token.nil?
#    expect(has_uid).to eq (true)
#    expect(has_provider).to eq (true)
#    expect(has_token).to eq (true)
#  end

#  it "should return save a token with a different value the older one" do
#    old_token = connected_gamer.token
#    connected_gamer.update_access_token(auth)
#    new_token = connected_gamer.token
#    new_token.should_not eq (old_token)
#  end

  it "should delete the user's provider, uid and token" do
    connected_gamer.disconnect_from_facebook
    has_uid = !connected_gamer.uid.nil?
    has_provider = !connected_gamer.provider.nil?
    has_token = !connected_gamer.token.nil?
    expect(has_uid).to eq (false)
    expect(has_provider).to eq (false)
    expect(has_token).to eq (false)
  end

  it "should return true because the user is connected" do
    is_connected = connected_gamer.is_connected_to_facebook
    expect(is_connected).to eq (true)
  end

  it "should return false because the user is not connected" do
    is_connected = gamer.is_connected_to_facebook
    expect(is_connected).to eq (false)
  end

  it "should not return nil since the user is connected and has a token" do
    token = connected_gamer.get_token
    token.should_not eq (nil)
  end

  it "should return nil since the user is not connected and has no token" do
    token = gamer.get_token
    token.should eq (nil)
  end
end