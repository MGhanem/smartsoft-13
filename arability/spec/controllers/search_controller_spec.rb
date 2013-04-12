# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers

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
  end
end
