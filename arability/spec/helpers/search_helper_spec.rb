#encoding: UTF-8
require 'spec_helper'

describe SearchHelper do

    let(:s){
      s = Synonym.new
        s.name =  "الثاني"
        s.keyword_id =  k.id
        s.approved = "true"
        s.save
        s

    }

    let(:g){
      g = Gamer.new
      g.username = "trialGThree"
      g.country = "Egypt"
      g.education_level = "low"
      g.date_of_birth = "Sun, 09 Apr 1995"
      g.gender = "male"
      g.email = "trialC@example.com"
      g.password = "123456"
      g.save
      g
    }

    let(:gTwo){
      gTwo = Gamer.new
      gTwo.username = "trialGFour"
      gTwo.country = "Saudi"
      gTwo.education_level = "high"
      gTwo.date_of_birth = "Sun, 09 Apr 1975"
      gTwo.gender = "female"
      gTwo.email = "trialD@example.com"
      gTwo.password = "123456"
      gTwo.save
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
      unvoted_synonym.name = "ثالثلا"
      unvoted_synonym.approved = "true"
      unvoted_synonym.save
      unvoted_synonym
    }

    let(:k){
      k = Keyword.new
      k.name ="trialKeywordA"
      k.is_english = "true"
      k.approved = "true"
      k.save
      k
    }

  before (:each) do
  k.should be_valid
  s.should be_valid
  g.should be_valid
  gTwo.should be_valid
  v.should be_valid
  vTwo.should be_valid
  end

   
      it "draws the chart for given synonym that shows gender statistics" do
        chart = piechart(s.id, 0)
        chart.first[:title][:text].should match(I18n.t(:stats_gender))
        chart.data.first[:data].should =~ (s.get_visual_stats_gender)
      end

      it "draws the chart for given synonym that shows country statistics" do
        chart = piechart(s.id, 1)
        chart.first[:title][:text].should match(I18n.t(:stats_country))
        chart.data.first[:data].should =~ (s.get_visual_stats_country)
      end

      it "draws the chart for given synonym that shows age statistics" do
        chart = piechart(s.id, 2)
        chart.first[:title][:text].should match(I18n.t(:stats_age))
        chart.data.first[:data].should =~ (s.get_visual_stats_age)
      end

      it "draws the chart for given synonym that shows age statistics" do
        chart = piechart(s.id, 3)
        chart.first[:title][:text].should match(I18n.t(:stats_education))
        chart.data.first[:data].should =~ (s.get_visual_stats_education)
      end
  
  




end