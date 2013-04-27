# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe GuestController do
  describe "POST #signing_up" do

    it "should be able to fill in the required details before playing" do
      expect{
        post :signing_up, gamer: {education_level: 'Graduate', gender: 'male', "date_of_birth(1i)" => '1993', "date_of_birth(2i)" => '12', "date_of_birth(3i)" => '28', country: 'Egypt'}
      }.to change(Gamer,:count).by(1)
    end

    it "should reenter his data if he entered something wrong" do
      expect{
        post :signing_up, gamer: {education_level: 'Graduate', gender: 'male', "date_of_birth(1i)" => '2013', "date_of_birth(2i)" => '12', "date_of_birth(3i)" => '28', country: 'Egypt'}
      }.to_not change(Gamer,:count)
    end
  end

  describe "POST #continue_signing_up" do
    it "should be able to continue with his signup afterwards" do
      post :signing_up, gamer: {education_level: 'Graduate', gender: 'male', "date_of_birth(1i)" => '1993', "date_of_birth(2i)" => '12', "date_of_birth(3i)" => '28', country: 'Egypt'}
      expect{
        post :continue_signing_up, gamer: {email: 'fattouh92@gmail.cdom', password: '123456', password_confirmation: '123456', username: 'fattouh92'}
      }.to change(Gamer,:count).by(1)
    end

    it "should his data when entering wrong data while continuing with his signup afterwards" do
      post :signing_up, gamer: {education_level: 'Graduate', gender: 'male', "date_of_birth(1i)" => '1993', "date_of_birth(2i)" => '12', "date_of_birth(3i)" => '28', country: 'Egypt'}
      expect{
        post :continue_signing_up, gamer: {email: 'fattouh92@gmail.cdom', password: '123456', password_confirmation: '1', username:'fattouh92'}
      }.to_not change(Gamer,:count)
    end
  end
end
