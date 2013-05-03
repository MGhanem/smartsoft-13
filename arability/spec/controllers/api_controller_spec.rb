# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe ApiController, mohamed: true do
  include Devise::TestHelpers

  let(:k) do
    success, keyword = Keyword.add_keyword_to_database("test", true)
    keyword
  end

  let(:k2) do
    success, keyword = Keyword.add_keyword_to_database("testing", true)
    keyword
  end


  let(:s) do
    s = Synonym.new
    s.name = "click"
    s.approved = true
    s.keyword = k
    s.save validate: false
    s
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
    gamer
  end

  let(:developer) do
    create_logged_in_developer
  end

  let(:api) { ApiKey.create(developer_id: developer.id, website: "test.com") }

  it "should get synonyms for keyword" do
    s
    get :get_synonyms, keywords: ["test"], api_key: api.token
    assigns(:result)[0]["translation"].should eq("click")
  end

  it "should not get synonyms for keyword if there are none" do
    k
    get :get_synonyms, keywords: ["test"], api_key: api.token
    assigns(:result)[0]["found"].should eq(false)
  end

  it "should not get synonyms if no keywords sent" do
    s
    get :get_synonyms, api_key: api.token
    response.should_not be_success
  end

  it "should get synonyms if overrides sent" do
    s
    get :get_synonyms, api_key: api.token, keywords: ["test"],
      overrides: { country: "Egypt" }
    assigns(:result)[0]["translation"].should eq("click")
  end

  it "should get index page if logged in" do
    login developer.gamer
    get :index
    response.should be_success
  end

  it "should create api key if logged in" do
    login developer.gamer
    get :create, api_key: { website: "www.test.com" }
    assigns(:api_key).website.should eq("www.test.com")
    assigns(:api_key).valid?.should eq(true)
  end

  it "should delete api key if you own it" do
    api
    login_gamer developer.gamer
    get :delete, api_key_id: api.id
    ApiKey.all.blank?.should eq(true)
  end

  it "should not delete api key if you donot own it" do
    api.developer_id = developer.id + 1
    api.save
    login_gamer developer.gamer
    get :delete, api_key_id: api.id
    response.should be_forbidden
  end

  it "should not create api key if no website sent" do
    login_gamer developer.gamer
    get :create
    assigns(:api_key).valid?.should eq(false)
  end
end
