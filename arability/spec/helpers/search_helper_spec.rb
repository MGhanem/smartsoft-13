#encoding: UTF-8
require 'spec_helper'

describe SearchHelper, search_helper_spec: true do
    
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
      g.save(validate: false)
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
        chart = piechart_gender(s.id, nil, nil, nil, nil)
        chart.first[:title][:text].should match(I18n.t(:stats_gender))
        chart.data.first[:data].should =~ (s.get_visual_stats_gender(nil, nil, nil, nil))
      end

      it "draws the chart for given synonym that shows country statistics" do
        chart = piechart_country(s.id, nil, nil, nil, nil)
        chart.first[:title][:text].should match(I18n.t(:stats_country))
        chart.data.first[:data].should =~ (s.get_visual_stats_country(nil, nil, nil, nil))
      end

      it "draws the chart for given synonym that shows age statistics" do
        chart = piechart_age(s.id, nil, nil, nil, nil)
        chart.first[:title][:text].should match(I18n.t(:stats_age))
        chart.data.first[:data].should =~ (s.get_visual_stats_age(nil, nil, nil, nil))
      end

      it "draws the chart for given synonym that shows education statistics" do
        chart = piechart_education(s.id, nil, nil, nil, nil)
        chart.first[:title][:text].should match(I18n.t(:stats_education))
        chart.data.first[:data].should =~ (s.get_visual_stats_education(nil, nil, nil, nil))
      end
end

