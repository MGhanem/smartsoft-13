# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe GuestController do
  describe "GET search" do
  include Devise::TestHelpers
    
    let(:k2) do
      success, keyword = Keyword.add_keyword_to_database("testing", true)
      keyword
    end

    let(:k3) do
      success, keyword = Keyword.add_keyword_to_database("ktest", false)
      keyword
    end

    it "not signed-in user should get redirected to a fill form page before playing " do
      get "/game"
      response.should redirect_to(guest_fill_form_path)
    end

    it "should be able to fill in the required details before playing" do
      get "/game"
      fill_in 'education', :with => 'Graduate'
      fill_in 'gender', :with => 'male'
      fill_in 'dob', :with => '1993-03-23'
      fill_in 'country', :with => 'Egypt'
      click_button "Submit"
      response.should redirect_to("/game")
    end

    it "should reenter his data if he entered something wrong" do
      get "/game"
      fill_in 'education', :with => 'Graduate'
      fill_in 'gender', :with => 'male'
      fill_in 'dob', :with => '2013-03-23'
      fill_in 'country', :with => 'Egypt'
      click_button "Submit"
      response.should redirect_to(guest_fill_form_path)
    end

    it "should be able to continue with his signup afterwards" do
      fill_in 'e-mail', :with => 'mohamed.aboul-azm@student.guc.edu.eg'
      fill_in 'password', :with => '123456'
      fill_in 'cPassword', :with => '123456'
      fill_in 'username', :with => 'fattouh92'
      click_button "Submit"
      response.should redirect_to("/game")
    end

  end
end
