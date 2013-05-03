# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers
include SearchHelper

describe SearchController do
  describe "GET search" do
  include Devise::TestHelpers
    let(:c) do
      success, category = Category.add_category("test", "سنبنتش")
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

    let(:my_sub) do
      my_sub = MySubscription.new
      my_sub.word_search = 1
      my_sub.save validate:false
      my_sub
    end

    before :each do
      k
      k2
    end

    let(:gamer3) do
      gamer = Gamer.new
      gamer.username = "Nourhan"
      gamer.country = "Lebanon"
      gamer.gender = "female"
      gamer.date_of_birth = "1970-03-23"
      gamer.email = "nourhanA@gmail.com"
      gamer.password = "1234567"
      gamer.education_level = "University"
      gamer.confirmed_at = Time.now
      gamer.save validate: false
      gamer
    end

    let(:gamer3_vote_s) {
      gamer3
      s
      success, vote = Vote.record_vote(gamer3.id, s.id)
      vote
    }

    let(:gamer4) do
      gamer = Gamer.new
      gamer.username = "Nourhan"
      gamer.country = "Egypt"
      gamer.gender = "male"
      gamer.date_of_birth = "1993-03-23"
      gamer.email = "nourhanB@gmail.com"
      gamer.password = "1234567"
      gamer.education_level = "Graduate"
      gamer.confirmed_at = Time.now
      gamer.save validate: false
      gamer
    end

    let(:gamer4_vote_s1) {
      gamer4
      s1
      success, vote = Vote.record_vote(gamer4.id, s1.id)
      vote
    }

    it "should get all keywords if no category specified", mohamed: true do
      k
      k2
      c.keywords << k
      a = create_logged_in_developer
      login(a.gamer)
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
      my_sub
      my_sub.developer_id = d.id
      my_sub
      my_sub.developer_id = d.id
      my_sub.save validate: false

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
      my_sub
      my_sub.developer_id = d.id
      my_sub.save validate: false

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

    it "should redirect to search_keywords path if search limit is exceeded",
      nourhan_mohamed: true do
      d = create_logged_in_developer
      sign_in(d.gamer)
      k
      k2
      my_sub
      my_sub.developer_id = d.id
      my_sub.save validate: false
      
      xhr :post, :search_with_filters, search: "test"
      response.code.should eq("200")
      
      get :search_with_filters, search: "testing"
      response.code.should eq("302")
      response.should redirect_to(search_keywords_path)

      get :search_with_filters, search: "test"
      response.code.should eq("200")
    end

    it "get the four pie charts corresponding to each synonym without filters", 
      nourhan_zakaria_test: true do
      d = create_logged_in_developer
      sign_in(d.gamer)

      k
      s
      s1
      s2
      gamer3
      gamer4
      gamer3_vote_s
      gamer4_vote_s1
      my_sub
      my_sub.developer_id = d.id
      my_sub.save validate: false

      get :search_with_filters, search: "test"

      assigns(:synonyms).should =~([s, s1])
      visuals = assigns(:charts).select { |f| f[s.id] }
      charts = visuals.first[s.id]

      charts[0].first[:title][:text].should match(I18n.t(:stats_gender))
      charts[0].data.first[:data]
        .should =~ (s.get_visual_stats_gender(nil, nil, nil, nil, nil))

      charts[1].first[:title][:text].should match(I18n.t(:stats_country))
      charts[1].data.first[:data]
        .should =~ (s.get_visual_stats_country(nil, nil, nil, nil, nil))

      charts[2].first[:title][:text].should match(I18n.t(:stats_age))
      charts[2].data.first[:data]
        .should =~ (s.get_visual_stats_age(nil, nil, nil, nil, nil))

      charts[3].first[:title][:text].should match(I18n.t(:stats_education))
      charts[3].data.first[:data]
        .should =~ (s.get_visual_stats_education(nil, nil, nil, nil, nil))

      visuals_s1 = assigns(:charts).select { |f| f[s1.id] }
      charts_s1 = visuals_s1.first[s1.id]

      charts_s1[0].first[:title][:text].should match(I18n.t(:stats_gender))
      charts_s1[0].data.first[:data]
        .should =~ (s1.get_visual_stats_gender(nil, nil, nil, nil, nil))

      charts_s1[1].first[:title][:text].should match(I18n.t(:stats_country))
      charts_s1[1].data.first[:data]
        .should =~ (s1.get_visual_stats_country(nil, nil, nil, nil, nil))

      charts_s1[2].first[:title][:text].should match(I18n.t(:stats_age))
      charts_s1[2].data.first[:data]
        .should =~ (s1.get_visual_stats_age(nil, nil, nil, nil, nil))

      charts_s1[3].first[:title][:text].should match(I18n.t(:stats_education))
      charts_s1[3].data.first[:data]
        .should =~ (s1.get_visual_stats_education(nil, nil, nil, nil, nil))
    end

    it "get the four pie charts corresponding to each synonym with filters", 
      nourhan_zakaria_test: true do
      d = create_logged_in_developer
      sign_in(d.gamer)

      k
      s
      s1
      s2
      gamer3
      gamer4
      gamer3_vote_s
      gamer4_vote_s1
      my_sub
      my_sub.developer_id = d.id
      my_sub.save validate: false

      get :search_with_filters, search: "test", country: "Lebanon", age_from: "10",
          age_to: "50", gender: "female", education: "University"

      assigns(:synonyms).should =~([s, s1])
      visuals = assigns(:charts).select { |f| f[s.id] }
      charts = visuals.first[s.id]
      charts[0].first[:title][:text].should match(I18n.t(:stats_gender))
      charts[0].data.first[:data]
        .should =~ (s.get_visual_stats_gender("female", "Lebanon", "University", 10, 50))

      charts[1].first[:title][:text].should match(I18n.t(:stats_country))
      charts[1].data.first[:data]
        .should =~ (s.get_visual_stats_country("female", "Lebanon", "University", 10, 50))

      charts[2].first[:title][:text].should match(I18n.t(:stats_age))
      charts[2].data.first[:data]
        .should =~ (s.get_visual_stats_age("female", "Lebanon", "University", 10, 50))
        
      charts[3].first[:title][:text].should match(I18n.t(:stats_education))
      charts[3].data.first[:data]
        .should =~ (s.get_visual_stats_education("female", "Lebanon", "University", 10, 50))
      charts[3].data.first[:data].should_not =~ []
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
