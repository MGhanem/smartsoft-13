#encoding: UTF-8
require 'spec_helper'

describe SearchHelper do
    
    let(:k){
      k = Keyword.new
      k.name ="trialKeywordA"
      k.is_english = "true"
      k.approved = "true"
      k.save
      k
    }

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
      g.education_level = "Graduate"
      g.date_of_birth = "Sun, 09 Apr 1995"
      g.gender = "male"
      g.email = "trialC@example.com"
      g.password = "1234567"
      g.save
      g
    }

    let(:gTwo){
      gTwo = Gamer.new
      gTwo.username = "trialGFour"
      gTwo.country = "Lebanon"
      gTwo.education_level = "University"
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

    before (:each) do
    v
    vTwo
    end


      it "draws the chart for given synonym that shows gender statistics" do
        puts Vote.all
        chart = piechart_gender(s.id)
        chart.first[:title][:text].should match(I18n.t(:stats_gender))
        chart.data.first[:data].should =~ (s.get_visual_stats_gender)
      end

      it "draws the chart for given synonym that shows country statistics" do
        chart = piechart_country(s.id)
        chart.first[:title][:text].should match(I18n.t(:stats_country))
        chart.data.first[:data].should =~ (s.get_visual_stats_country)
      end

      it "draws the chart for given synonym that shows age statistics" do
        chart = piechart_age(s.id)
        chart.first[:title][:text].should match(I18n.t(:stats_age))
        chart.data.first[:data].should =~ (s.get_visual_stats_age)
      end

      it "draws the chart for given synonym that shows education statistics" do
        chart = piechart_education(s.id)
        chart.first[:title][:text].should match(I18n.t(:stats_education))
        chart.data.first[:data].should =~ (s.get_visual_stats_education)
      end
  
  




end