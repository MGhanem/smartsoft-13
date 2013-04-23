#encoding: UTF-8
require 'spec_helper'

describe Gamer, vote_log_test: true do
    
  let(:k){
    k = Keyword.new
    k.name ="trialKeywordA"
    k.is_english = "true"
    k.approved = "true"
    k.save
    k
  }

  let(:kTwo){
    k = Keyword.new
    k.name ="trialKeywordb"
    k.is_english = "true"
    k.approved = "true"
    k.save
    k
  }

    let(:kThree){
    k = Keyword.new
    k.name ="trialKeywordC"
    k.is_english = "true"
    k.approved = "false"
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

  let(:sTwo){
    s = Synonym.new
    s.name =  "الثاني"
    s.keyword_id =  k.id
    s.approved = "true"
    s.save
    s

  }

  let(:sThree){
    s = Synonym.new
    s.name =  "الثالت"
    s.keyword_id =  k.id
    s.approved = "true"
    s.save
    s

  }

  let(:sFour){
    s = Synonym.new
    s.name =  "الرابع"
    s.keyword_id =  kTwo.id
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


  before (:each) do
  k
  kTwo
  s
  sTwo
  sThree
  sFour
  g
  gTwo
  v
  end


  describe "get_votes" do 
      it "returns the number of votes and a list of lists of chosen synonyms' names and their corresponding keywords' names" do
        Vote.record_vote(gTwo.id, s.id)
        Vote.record_vote(gTwo.id, sFour.id)
        count, vote_log_list = gTwo.get_votes
        count.should eq(2)
        vote_log_list =~ [["trialKeywordA", "الثاني"],["trialKeywordb", "الرابع"]]
      end

      it "returns 0 and empty list when the gamer never voted on any synonym before" do
        count, vote_log_list = gTwo.get_votes
        count.should eq(0)
        vote_log_list =~ []
      end
  end
end