# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe SearchController do
  describe "GET search" do
  include Devise::TestHelpers
    let(:c) do
      success, category = Category.add_category_to_database_if_not_exists("test", "سنبنتش")
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
      gamer.gender = "female"
      gamer.date_of_birth = "1993-03-23"
      gamer.email = "nour@gmail.com"
      gamer.password = "1234567"
      gamer.save validate: false
    end

    it "should get only keywords in category" do
      c.keywords << k
      a = create_logged_in_developer
      sign_in(a.gamer)
      get :search_keywords, :categories => "سنبنتش", :search => "test"
      assigns(:similar_keywords).should =~ [k]
    end

    it "should get all keywords if no category specified" do
      c.keywords << k
      k2
      a = create_logged_in_developer
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
      assigns(:similar_keywords).should =~ [k, k2]
    end
  end
end
