#encoding: UTF-8
require 'spec_helper'

describe Vote, vote_test: true do
    
  let(:k){
    k = Keyword.new
    k.name = "trialKeywordA"
    k.is_english = true
    k.approved = true
    k.save
    k
  }

  let(:kTwo){
    k = Keyword.new
    k.name = "trialKeywordb"
    k.is_english = true
    k.approved = true
    k.save
    k
  }

  let(:kThree){
    k = Keyword.new
    k.name = "trialKeywordC"
    k.is_english = true
    k.approved = false
    k.save
    k
  }

  let(:kFour){
    k = Keyword.new
    k.name = "trialKeywordD"
    k.is_english = false
    k.approved = true
    k.save
    k
  }

  let(:kFive){
    k = Keyword.new
    k.name = "trialKeywordE"
    k.is_english = false
    k.approved = true
    k.save
    k
  }

  let(:s){
    s = Synonym.new
    s.name = "الثاني"
    s.keyword_id = k.id
    s.approved = true
    s.save
    s

  }

  let(:sTwo){
    s = Synonym.new
    s.name = "الثاني"
    s.keyword_id = k.id
    s.approved = true
    s.save
    s

  }

  let(:sThree){
    s = Synonym.new
    s.name = "الثالث"
    s.keyword_id = k.id
    s.approved = true
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
    kThree
    kFour
    kFive
    s
    sTwo
    sThree
    g
    gTwo
    v
  end

  describe "record_vote" do
    it "record vote given to a certain synonym it saves it and returns true
      if this gamer didn't vote for this synonym before otherwise it doesn't 
      save and return false" do
      success, vote_instance = Vote.record_vote(gTwo.id, sTwo.id)
      success.should eq(true)
      checkagain, vote_again = Vote.record_vote(gTwo.id, sTwo.id)
      checkagain.should eq(false)
    end

    it "doesn't allow gamer to vote for synonym that belongs to Keyword 
      that he/she voted for one of its synonyms before" do
      success, vote_instance = Vote.record_vote(g.id, sTwo.id)
      success.should eq(false)
      success_again, vote_instance_again = Vote.record_vote(g.id, sThree.id)
      success_again.should eq(false)
    end

    it "never record a vote for a non existing gamer" do
      success, vote_instance = Vote.record_vote(100000000, sTwo.id)
      success.should eq(false)
      vote_instance.errors.messages.should 
        eq({ gamer_id: ["this gamer_id doesn't exist"] })
    end
    it "never record a vote for a non existing synonym" do
      success, vote_instance = Vote.record_vote(g.id, 1000000000)
      success.should eq(false)
      vote_instance.errors.messages.should 
        eq({ synonym_id: ["this synonym_id doesn't exist"] })
    end
  end

  describe "get_lang_english" do
    it "returns 0" do
      lang = Vote.get_lang_english 
      lang.should eq(0)
    end
  end

  describe "get_lang_arabic" do
    it "returns 1" do
      lang = Vote.get_lang_arabic 
      lang.should eq(1)
    end
  end

  describe "get_lang_both" do
    it "returns 2" do
      lang = Vote.get_lang_both 
      lang.should eq(2)
    end
  end

  describe "get_unvoted_keywords" do
    it "get list of unvoted approved keywords of the specified size for 
      certain user" do
      keywords_list_gamer_one = Vote.get_unvoted_keywords(g.id, 0, 2)
      keywords_list_gamer_one.should =~ []
      keywords_list_gamer_one_a = Vote.get_unvoted_keywords(g.id, 1, 2)
      keywords_list_gamer_one_a.length.should eq(1)
      keywords_list_gamer_two = Vote.get_unvoted_keywords(gTwo.id, 2, 2)
      keywords_list_gamer_two.length.should eq(2)
      keywords_list_gamer_one_b = Vote.get_unvoted_keywords(g.id, 3, 2)
      keywords_list_gamer_one_b.should include(kTwo, kFour, kFive)
      keywords_list_gamer_one_b.should_not include(k)
      keywords_list_gamer_one_b.length.should eq(3)
    end

    it "never returns a word this gamer voted on before and never return non 
      approved keyword" do
      keywords_list = Vote.get_unvoted_keywords(g.id, 2, 2)
      keywords_list.should_not include(k)
      keywords_list.should include || (kTwo) || (kFour) || (kFive)
      keywords_list.should_not include(kThree)
      keywords_list.length.should eq(2)
      keywords_list_one = Vote.get_unvoted_keywords(g.id, 3, 2)
      keywords_list_one.should_not include(k)
      keywords_list_one.should include(kTwo) 
      keywords_list_one.should include(kFour) 
      keywords_list_one.should include(kFive)
      keywords_list_one.should_not include(kThree)
      keywords_list_one.length.should eq(3)
    end

    it "return the unvoted keywords with the specified language" do
      Vote.record_vote(gTwo.id,s.id)
      keywords_list_english = Vote.get_unvoted_keywords(gTwo.id, 5, 0)
      keywords_list_english.should_not include(kFour)
      keywords_list_english.should_not include(kFive)
      keywords_list_english.should_not include(k)
      keywords_list_english.should_not include(kThree)
      keywords_list_english.should include(kTwo)
      keywords_list_english.length.should eq(1)
      keywords_list_arabic = Vote.get_unvoted_keywords(gTwo.id, 5, 1)
      keywords_list_arabic.should include(kFour)
      keywords_list_arabic.should include(kFive)
      keywords_list_arabic.should_not include(k)
      keywords_list_arabic.should_not include(kThree)
      keywords_list_arabic.should_not include(kTwo)
      keywords_list_arabic.length.should eq(2)
    end
  end
end