# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe KeywordsController do

    let(:c) do
      success, category = Category.add_category("test", "سنبنتش")
      category
    end

    let(:c2) do
      success, category = Category.add_category("testing", "سنب نتش")
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

  describe "GET new", mohamed: true do
    it "Should get the new form" do
      d = create_logged_in_developer
      sign_in d.gamer
      get :new, name: "test", category_ids: "1,2,3,4"
      assigns(:keyword).name.should eq("test")
      assigns(:category_ids).should =~ ["1", "2", "3", "4"]
    end

  end
  describe "POST create", mohamed: true do
    it "should create a new keyword" do
      d = create_logged_in_developer
      sign_in d.gamer
      post :create, category_ids: [c.id], keyword: {name: "test"}
      assigns(:keyword).categories.include?(c).should eq(true)
    end

    it "should not create a new keyword if not passes validation" do
      d = create_logged_in_developer
      sign_in d.gamer
      post :create, category_ids: [c.id], keyword: {name: "test2"}
      assigns(:keyword).valid?.should eq(false)
    end

    it "should add category to original keyword" do
      d = create_logged_in_developer
      sign_in d.gamer
      k
      post :create, category_ids: [c.id], keyword: {name: "test"}
      assigns(:keyword).categories.include?(c).should eq(true)
    end

    it "should add category to original keyword" do
      d = create_logged_in_developer
      sign_in d.gamer
      k
      post :create, keyword: {name: "test"}
      flash[:error].present?.should eq(true)
    end

    it "should replace categories of original keyword" do
      d = create_logged_in_developer
      sign_in d.gamer
      k.categories = [c]
      post :create, category_ids: [c2.id], keyword: {name: "test"}, override_categories: "true"
      assigns(:keyword).categories.include?(c).should eq(false)
      assigns(:keyword).categories.include?(c2).should eq(true)
    end

    it "should not replace categories of original keyword" do
      d = create_logged_in_developer
      sign_in d.gamer
      k.categories = [c]
      post :create, category_ids: [c2.id], keyword: {name: "test"}
      assigns(:keyword).categories.include?(c).should eq(true)
      assigns(:keyword).categories.include?(c2).should eq(true)
    end
  end
end
