#encoding: UTF-8
require "spec_helper"

describe GamesController, vote_log_test: true do

  let(:k) {
    k = Keyword.new
    k.name = "trialKeywordA"
    k.is_english = true
    k.approved = true
    k.save
    k
  }

  let(:kTwo) {
    k = Keyword.new
    k.name = "trialKeywordb"
    k.is_english = true
    k.approved = true
    k.save
    k
  }

  let(:kThree) {
    k = Keyword.new
    k.name = "trialKeywordC"
    k.is_english = true
    k.approved = false
    k.save
    k
  }

  let(:s) {
    s = Synonym.new
    s.name = "الاول"
    s.keyword_id = k.id
    s.approved = true
    s.save
    s
  }

  let(:sTwo) {
    s = Synonym.new
    s.name = "الثاني"
    s.keyword_id = k.id
    s.approved = true
    s.save
    s
  }

  let(:sThree) {
    s = Synonym.new
    s.name = "الثالت"
    s.keyword_id = k.id
    s.approved = true
    s.save
    s
  }

  let(:sFour) {
    s = Synonym.new
    s.name = "الرابع"
    s.keyword_id = kTwo.id
    s.approved = true
    s.save
    s
  }

  let(:g) {
    g = Gamer.new
    g.username = "trialVoter"
    g.country = "Egypt"
    g.education_level = "Graduate"
    g.date_of_birth = "Sun, 09 Apr 1995"
    g.gender = "male"
    g.email = "trialC@example.com"
    g.password = "1234567"
    g.save validate: false
    g
  }

  let(:gTwo) {
    gTwo = Gamer.new
    gTwo.username = "trialVoterTwo"
    gTwo.country = "Lebanon"
    gTwo.education_level = "School"
    gTwo.date_of_birth = "Sun, 09 Apr 1980"
    gTwo.gender = "female"
    gTwo.email = "trialD@example.com"
    gTwo.password = "1234567"
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
    v = Vote.new
    v.synonym_id = sFour.id
    v.gamer_id = g.id
    v.save
    v
  }

  let(:vThree) {
    v = Vote.new
    v.synonym_id = s.id
    v.gamer_id = gTwo.id
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
  end

  describe "showProfile" do
    it "gets the list of voted keywords and their corresponding voted 
      synonyms of current gamer" do
      sign_in(g)
      v
      vTwo
      get :showprofile
      assigns(:count).should eq(2)
      assigns(:vote_log).should =~ 
        [["trialKeywordA", "الاول"], ["trialKeywordb", "الرابع"]]
    end

    it "gets 1 and a list of one list only when the gamer voted only once" do
      sign_in(gTwo)
      vThree
      get :showprofile
      assigns(:count).should eq(1)
      assigns(:vote_log).should =~ [["trialKeywordA", "الاول"]]
    end

    it "gets 0 and [] when calling get_votes on gamer that has no votes
     history yet " do
      sign_in(gTwo)
      get :showprofile
      assigns(:count).should eq(0)
      assigns(:vote_log).should =~ []
    end
  end
end