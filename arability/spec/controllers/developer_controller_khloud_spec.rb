#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe DeveloperController do

    let(:gamer) {
      gamer = Gamer.new
      gamer.username = "Khloud"
      gamer.country = "Egypt"
      gamer.education_level = "high"
      gamer.gender = "female"
      gamer.date_of_birth = "1993-08-02"
      gamer.email = "khloud.khalid7@gmail.com"
      gamer.password = "1234567"
      gamer.save
      gamer
    }

    it "should redirect to project path if current gamer is already a developer" do
      d = Developer.new
      d.verified = true
      d.gamer_id = gamer.id 
      d.save
      current_gamer = gamer
      get :new
      response.should redirect_to :projects_path
    end

    it "should create new developer and redirect to choose subscription model page if current gamer is not a developer" do
      current_gamer = gamer
      get :new
      assigns(@developer.gamer_id).should == gamer.id
      response.should redirect_to :choose_sub_path
    end
end
