# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe SearchController do
  describe "GET search" do
  include Devise::TestHelpers
    let(:c) do
      success, category = Category.add_category_to_database_if_not_exists("test")
      category
    end

    let(:k) do
      success, keyword = Keyword.add_keyword_to_database("test", true)
      keyword
    end

    let(:k2) do
      success, keyword = Keyword.add_keyword_to_database("testing", true)
      keyword
    end

    let(:k3) do
      success, keyword = Keyword.add_keyword_to_database("ktest", false)
      keyword
    end

    let(:gamer) do
      gamer = Gamer.new
      gamer.username = "Nourhan"
      gamer.country = "Egypt"
      gamer.education_level = "high"
      gamer.gender = "female"
      gamer.date_of_birth = "1993-03-23"
      gamer.email = "nour@gmail.com"
      gamer.password = "1234567"
      gamer.save validate: false
    end

    it "should get only keywords in category" do
      c.keywords << k
      a = create_logged_in_developer()
      sign_in(a.gamer)
      get :search_keywords, :categories => "test", :search => "test"
      assigns(:categories).should eq("test")
      assigns(:similar_keywords).should =~ [k]
    end

    it "should get all keywords if no category specified" do
      c.keywords << k
      k2
      a = create_logged_in_developer()
      sign_in(a.gamer)
      get :search_keywords, :search => "test"
      assigns(:similar_keywords).should =~ [k, k2]
    end

    it "should list keywords according to search" do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      k2
      get :search_keywords, search: "test"
      assigns(:similar_keywords).should == [k, k2]
      assigns(:similar_keywords).should_not == [k2, k]
    end

    it "should return json containing similar keywords" do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      k2
      k3
      get :keyword_autocomplete, search: "test"
      json_response = JSON(response.body)
      json_response.first.should eq("test")
      json_response.last.should eq("testing")
    end

    it "should return empty json on not-found" do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      k2
      k3
      get :keyword_autocomplete, search: "click"
      json_response = JSON(response.body)
      json_response.should == []
    end

    it "should return empty json on non-approved keywords" do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      k2
      k3
      get :keyword_autocomplete, search: "ktest"
      json_response = JSON(response.body)
      json_response.should == []
    end
  end
end
