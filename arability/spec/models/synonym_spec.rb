#encoding: UTF-8
require 'spec_helper'


describe Synonym do 

    let(:k){
      k = Keyword.new
      k.name ="trialKeyword"
      k.is_english = "true"
      k.approved = "true"
      k.save
      k
    }

    let(:s){
      s = Synonym.new
        s.name =  "معني"
        s.keyword_id =  k.id
        s.approved = "true"
        s.save
        s

    }

    let(:g){
      g = Gamer.new
      g.username = "trialGamer"
      g.country = "Egypt"
      g.education_level = "University"
      g.date_of_birth = "Sun, 09 Apr 1995"
      g.gender = "male"
      g.email = "trialA@example.com"
      g.password = "123456"
      g.save(validate: false)
      g
    }

    let(:gTwo){
      gTwo = Gamer.new
      gTwo.username = "trialGTwo"
      gTwo.country = "Lebanon"
      gTwo.education_level = "Graduate"
      gTwo.date_of_birth = "Sun, 09 Apr 1975"
      gTwo.gender = "female"
      gTwo.email = "trialB@example.com"
      gTwo.password = "123456"
      gTwo.save(validate: false)
      gTwo
    }

    let(:v){
      v = Vote.new
      v.synonym_id = s.id
      v.gamer_id = g.id
      v.save
      v
    }


    let(:vTwo){
      vTwo = Vote.new
      vTwo.synonym_id = s.id
      vTwo.gamer_id = gTwo.id
      vTwo.save
      vTwo
    }

    let(:unvoted_synonym){
      unvoted_synonym = Synonym.new
      unvoted_synonym.name = "لا"
      unvoted_synonym.keyword_id = "100"
      unvoted_synonym.approved = "true"
      unvoted_synonym.save
      unvoted_synonym
    }

  before (:each) do
    v
    vTwo
  end


  describe "get_visual_stats_gender" do
  it "returns the genders of voters and correponding percenteges of voters belong to each gender" do
    puts Vote.all
   s.get_visual_stats_gender.should =~ [[I18n.t(:male), 50], [I18n.t(:female), 50]]
  end

  it "returns an empty list when the synonym has no votes" do
   unvoted_synonym.get_visual_stats_gender.should == []
  end

  end

   describe "get_visual_stats_country" do 

  it "returns the list of countries of voters and correponding percenteges of voters from each country" do
   s.get_visual_stats_country.should =~ [[I18n.t(:egypt), 50], [I18n.t(:lebanon), 50]]
  end

  it "returns an empty list when the synonym has no votes" do
   unvoted_synonym.get_visual_stats_country.should =~ []
  end

  end

   describe "get_visual_stats_age" do 

  it "returns the list of age groups of voters and correponding percenteges of voters from each age group" do
   s.get_visual_stats_age.should =~ [["10-25", 50], ["26-45", 50], ["46+", 0]]
  end

  it "returns an empty list when the synonym has no votes" do
   unvoted_synonym.get_visual_stats_country.should =~ []
  end

  end

   describe "get_visual_stats_education" do 

  it "returns the list of education levels of voters and correponding percenteges of voters belong to each level" do
   s.get_visual_stats_education.should =~ [[I18n.t(:university), 50], [I18n.t(:graduate), 50]]
  end

  it "returns an empty list when the synonym has no votes" do
  unvoted_synonym.get_visual_stats_education.should =~ []
  end

  end
end
