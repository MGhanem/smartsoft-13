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

    let(:s) {
      k
      s = Synonym.create(name: "ابت", keyword_id: k.id, approved: true, is_formal: true)
      s
    }

    let(:s1) {
      k
      s = Synonym.create(name: "ابتث", keyword_id: k.id, approved: true, is_formal: false)
      s
    }

    let(:s2) {
      k
      s = Synonym.create(name: "ابتثج", keyword_id: k.id, approved: false)
      s
    }

    let(:gamer_vote_s) {
      gamer
      s
      success, vote = Vote.record_vote(gamer.id, s.id)
      vote
    }

    let(:gamer2_vote_s1) {
      gamer2
      s1
      success, vote = Vote.record_vote(gamer2.id, s1.id)
      vote
    }

    let(:gamer) do
      gamer = Gamer.new
      gamer.username = "Nourhan"
      gamer.country = "Egypt"
      gamer.gender = "female"
      gamer.date_of_birth = "1993-03-23"
      gamer.email = "nour@gmail.com"
      gamer.password = "1234567"
      gamer.education_level = "medium"
      gamer.confirmed_at = Time.now
      gamer.save validate: false
      gamer
    end

    let(:gamer2) do
      gamer = Gamer.new
      gamer.username = "Nourhan"
      gamer.country = "Qattar"
      gamer.gender = "female"
      gamer.date_of_birth = "1993-03-23"
      gamer.email = "nour@gmail.com"
      gamer.password = "1234567"
      gamer.education_level = "high"
      gamer.confirmed_at = Time.now
      gamer.save validate: false
      gamer
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

    it "should list keywords according to search", nourhan_mohamed: true do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      k2
      get :search_keywords, search: "test"
      assigns(:similar_keywords).should eq([k, k2])
      assigns(:similar_keywords).should_not eq([k2, k])
    end

    it "should list synonyms according to vote count", nourhan_mohamed: true do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      s
      s1
      s2
      gamer_vote_s
      get :search_with_filters, search: "test    ", synonym_type: 0
      assigns(:synonyms).should eq([s, s1])
      assigns(:votes)[1].should eq(1)
      assigns(:votes)[2].should be_nil
    end

    it "should list synonyms according to vote count upon filtering", nourhan_mohamed: true do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      s
      s1
      s2
      gamer_vote_s

      get :search_with_filters, search: "test", country: "Qattar", age_from: "40",
        age_to: "19", education: "high", gender: "female", synonym_type: 0 
      assigns(:synonyms).should eq([s, s1])
      assigns(:votes)[1].should be_nil
      assigns(:votes)[2].should be_nil

      get :search_with_filters, search: "test", country: "Qattar", age_from: "40",
        age_to: "19", education: "high", gender: "female", synonym_type: 2
      assigns(:synonyms).should eq([s1])
      assigns(:votes)[1].should be_nil
      assigns(:votes)[2].should be_nil

      get :search_with_filters, search: "test", country: "Egypt", age_from: "40",
        age_to: "19", gender: "female", education: "medium", synonym_type: 1
      assigns(:synonyms).should eq([s])
      assigns(:votes)[1].should eq(1)
      assigns(:votes)[2].should be_nil
    end

    it "should redirect to search_keywords action if passed a non existing keyword 
      to search or search_by_filters action", nourhan_mohamed: true do
      d = create_logged_in_developer
      sign_in(d.gamer)

      get :search_with_filters, search: "abc"
      response.code.should eq("302")
      response.should redirect_to(search_keywords_path(search: "abc"))

      get :search_with_filters, search: "abc"
      response.code.should eq("302")
      response.should redirect_to(search_keywords_path(search: "abc"))
    end

    it "should redirect to search_keywords action if passed an empty string 
      to search or search_by_filters action", nourhan_mohamed: true do
      d = create_logged_in_developer
      sign_in(d.gamer)

      get :search_with_filters, search: ""
      response.code.should eq("302")
      response.should redirect_to(search_keywords_path)

      get :search_with_filters, search: ""
      response.code.should eq("302")
      response.should redirect_to(search_keywords_path)
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

    it "should send report on a keyword successfully" do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      get :send_report, reported_words: ["#{k.id} Keyword"]
      assigns(:success).should be(true)
    end

    it "should send report on a synonym successfully" do
      d = create_logged_in_developer
      sign_in(d.gamer)
      s
      get :send_report, reported_words: ["#{s.id} Synonym"]
      assigns(:success).should be(true)
    end

    it "should send report on both keywords and synonyms successfully" do
      d = create_logged_in_developer
      sign_in(d.gamer)
      s2
      k2
      get :send_report, reported_words: ["#{s2.id} Synonym", "#{k2.id} Keyword"]
      assigns(:success).should eq(true)
    end
  end
end
