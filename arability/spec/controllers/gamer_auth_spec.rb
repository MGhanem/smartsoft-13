require 'spec_helper'
include Warden::Test::Helpers

describe 'Allowing gamer to signin with username or email' do

  let(:gamer_adam) {
    gamer_adam = Gamer.new
    gamer_adam.username = 'adamggg'
    gamer_adam.email = 'ag@developer.com'
    gamer_adam.password = 'password123'
    gamer_adam.password_confirmation = 'password123'
    gamer_adam.save validate: false
    gamer_adam
  }

  before(:each) do
    gamer_adam
  end

  it "should be able to find gamer using his username and sign them in" do
    gamer = Gamer.find_for_database_authentication(username: 'adamggg')
    gamer.should eq(gamer_adam)
    sign_in(gamer)
  end

  it "should be able to find gamer using his email and sign them in" do
    gamer = Gamer.find_for_database_authentication(email: 'ag@developer.com')
    gamer.should eq(gamer_adam)
    sign_in(gamer)
  end

  it "should not be able to find gamer using an email that does not exist" do
    gamer = Gamer.find_for_database_authentication(email: 'gaga@developer.com')
    gamer.should eq(nil)
  end

  it "should not be able to find gamer using a username that does not exist" do
    gamer = Gamer.find_for_database_authentication(username: 'gaga')
    gamer.should eq(nil)
  end
end

