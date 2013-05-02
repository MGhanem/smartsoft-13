#encoding: UTF-8
require 'spec_helper'

describe Synonym, synonym_spec: true  do 

    let(:k) {
      k = Keyword.new
      k.name = "trialKeyword"
      k.is_english = true
      k.approved = true
      k.save
      k
    }

    let(:s) {
      s = Synonym.new
      s.name = "معني"
      s.keyword_id = k.id
      s.approved = true
      s.save
      s
    }

    let(:sTwo) {
      s = Synonym.new
      s.name = "معني ثاني"
      s.keyword_id = k.id
      s.approved = true
      s.save
      s
    }

    let(:g) {
      g = Gamer.new
      g.username = "trialGamer"
      g.country = "Egypt"
      g.education_level = "University"
      g.date_of_birth = "Sun, 09 Apr 1995"
      g.gender = "male"
      g.email = "trialA@example.com"
      g.password = "123456"
      g.confirmed_at = Time.now
      g.save validate: false
      g
    }

    let(:gTwo) {
      gTwo = Gamer.new
      gTwo.username = "trialGTwo"
      gTwo.country = "Lebanon"
      gTwo.education_level = "Graduate"
      gTwo.date_of_birth = "Sun, 09 Apr 1975"
      gTwo.gender = "female"
      gTwo.email = "trialB@example.com"
      gTwo.password = "123456"
      gTwo.confirmed_at = Time.now
      gTwo.save validate: false
      gTwo
    }

    let(:gThree) {
      gTwo = Gamer.new
      gTwo.username = "trialGThree"
      gTwo.country = "Egypt"
      gTwo.education_level = "University"
      gTwo.date_of_birth = "Sun, 09 Apr 1975"
      gTwo.gender = "male"
      gTwo.email = "trialC@example.com"
      gTwo.password = "123456"
      gTwo.confirmed_at = Time.now
      gTwo.save validate: false
      gTwo
    }

    let(:gFour) {
      gTwo = Gamer.new
      gTwo.username = "trialGFour"
      gTwo.country = "Egypt"
      gTwo.education_level = "University"
      gTwo.gender = "male"
      gTwo.email = "trialD@example.com"
      gTwo.password = "123456"
      gTwo.confirmed_at = Time.now
      gTwo.save validate: false
      gTwo
    }

    let(:v) {
      v = Vote.new
      v.synonym_id = s.id
      v.gamer_id = g.id
      v.save
      v
    }

    let(:vTwo) {
      vTwo = Vote.new
      vTwo.synonym_id = s.id
      vTwo.gamer_id = gTwo.id
      vTwo.save
      vTwo
    }

    let(:unvoted_synonym) {
      unvoted_synonym = Synonym.new
      unvoted_synonym.name = "لا"
      unvoted_synonym.keyword_id = "100"
      unvoted_synonym.approved = true
      unvoted_synonym.save
      unvoted_synonym
    }

    before (:each) do
      gThree
      v
      vTwo
      gFour
      sTwo
    end


  describe "get_visual_stats_gender" do

    it "returns the genders of voters and correponding percenteges of 
      voters belong to each gender" do
      s.get_visual_stats_gender(nil, nil, nil, nil, nil)
        .should =~ [[I18n.t(:male), 50], [I18n.t(:female), 50]]
    end

    it "returns an empty list when the synonym has no votes" do
      unvoted_synonym.get_visual_stats_gender(nil, nil, nil, nil, nil).should =~ []
    end

    it "applies gender filter to voters if it exists" do
      s.get_visual_stats_gender("male", nil, nil, nil, nil)
        .should =~ [[I18n.t(:male), 100]]
    end

    it "applies country filter to voters if it exists" do
      s.get_visual_stats_gender(nil, "Lebanon", nil, nil, nil)
        .should =~ [[I18n.t(:female), 100]]
    end

    it "applies education filter to voters if it exists" do
      s.get_visual_stats_gender(nil, nil, "Graduate", nil, nil)
        .should =~ [[I18n.t(:female), 100]]
    end

    it "applies upper age limit filter if it exists" do
      s.get_visual_stats_gender(nil, nil, nil, nil, 20)
        .should =~ [[I18n.t(:male), 100]]
    end

    it "applies more than filter on voters if they exist" do 
      s.get_visual_stats_gender(nil, "Lebanon", "Graduate", nil, 45)
        .should =~ [[I18n.t(:female), 100]]
    end

  end

  describe "get_visual_stats_country" do 

    it "returns the list of countries of voters and correponding percenteges of 
      voters from each country" do
      s.get_visual_stats_country(nil, nil, nil, nil, nil)
        .should =~ [[I18n.t(:egypt), 50], [I18n.t(:lebanon), 50]]
    end

    it "returns an empty list when the synonym has no votes" do
      unvoted_synonym.get_visual_stats_country(nil, nil, nil, nil, nil).should =~ []
    end

    it "applies gender filter to voters if it exists" do
      s.get_visual_stats_country("male", nil, nil, nil, nil)
        .should =~ [[I18n.t(:egypt), 100]]
    end

    it "applies country filter to voters if it exists" do
      s.get_visual_stats_country(nil, "Lebanon", nil, nil, nil)
        .should =~ [[I18n.t(:lebanon), 100]]
    end

    it "applies education filter to voters if it exists" do
      s.get_visual_stats_country(nil, nil, "Graduate", nil, nil)
        .should =~ [[I18n.t(:lebanon), 100]]
    end

    it "applies upper age limit filter if it exists" do
      s.get_visual_stats_country(nil, nil, nil, nil, 20)
        .should =~ [[I18n.t(:egypt), 100]]
    end

    it "applies more than filter on voters if they exist" do 
      s.get_visual_stats_country("male", nil, "University", nil, 45)
        .should =~ [[I18n.t(:egypt), 100]]
    end

  end

  describe "get_visual_stats_age" do 

  it "returns the list of age groups of voters and correponding percenteges of 
    voters from each age group" do
    s.get_visual_stats_age(nil, nil, nil, nil, nil)
      .should =~ [["10-25", 50], ["26-45", 50], ["46+", 0]]
    end

    it "returns an empty list when the synonym has no votes" do
      unvoted_synonym.get_visual_stats_age(nil, nil, nil, nil, nil).should =~ []
    end

    it "returns an empty list when the voter or voters of synonym has date of birth nil" do
      Vote.record_vote(gFour.id, sTwo.id)
      sTwo.get_visual_stats_age(nil, nil, nil, nil, nil).should =~ []
    end

    it "applies gender filter to voters if it exists" do
      s.get_visual_stats_age("male", nil, nil, nil, nil)
        .should =~ [["10-25", 100], ["26-45", 0], ["46+", 0]]
    end

    it "applies country filter to voters if it exists" do
      s.get_visual_stats_age(nil, "Lebanon", nil, nil, nil)
        .should =~ [["10-25", 0], ["26-45", 100], ["46+", 0]]
    end

    it "applies education filter to voters if it exists" do
      s.get_visual_stats_age(nil, nil, "Graduate", nil, nil)
        .should =~ [["10-25", 0], ["26-45", 100], ["46+", 0]]
    end

    it "applies upper age limit filter if it exists" do
      s.get_visual_stats_age(nil, nil, nil, nil, 20)
        .should =~ [["10-25", 100], ["26-45", 0], ["46+", 0]]
    end

    it "applies more than filter on voters if they exist" do 
      s.get_visual_stats_age("male", "Egypt", "University", nil, nil)
        .should =~ [["10-25", 100], ["26-45", 0], ["46+", 0]]
    end

  end

  describe "get_visual_stats_education" do 

    it "returns the list of education levels of voters and correponding percenteges of 
      voters belong to each level" do
      s.get_visual_stats_education(nil, nil, nil, nil, nil)
        .should =~ [[I18n.t(:university), 50], [I18n.t(:graduate), 50]]
    end

    it "returns an empty list when the synonym has no votes" do
      unvoted_synonym.get_visual_stats_education(nil, nil, nil, nil, nil).should =~ []
    end

    it "applies gender filter to voters if it exists" do
      s.get_visual_stats_education("male", nil, nil, nil, nil)
        .should =~ [[I18n.t(:university), 100]]
    end

    it "applies country filter to voters if it exists" do
      s.get_visual_stats_education(nil, "Lebanon", nil, nil, nil)
        .should =~ [[I18n.t(:graduate), 100]]
    end

    it "applies education filter to voters if it exists" do
     s.get_visual_stats_education(nil, nil, "Graduate", nil, nil)
      .should =~ [[I18n.t(:graduate), 100]]
    end

    it "applies upper age limit filter if it exists" do
      s.get_visual_stats_education(nil, nil, nil, nil, 20)
        .should =~ [[I18n.t(:university), 100]]
    end

    it "applies more than filter on voters if they exist" do 
      s.get_visual_stats_education("male", "Egypt", nil, nil, 20)
        .should =~ [[I18n.t(:university), 100]]
    end

  end
end
