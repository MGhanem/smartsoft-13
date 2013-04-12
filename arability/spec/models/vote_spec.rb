#encoding: UTF-8
require 'spec_helper'

describe Vote do
    
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
      g.save (validate: false)
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
      gTwo.save (validate: false)
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
    g
    gTwo
    v
    end

    describe "record_vote" do
      it"record vote given to a certain synonym it saves it and returns true if this gamer didn't vote for this synonym before otherwise it doesn't save and return false" do
        success, vote_instance = Vote.record_vote(gTwo.id, sTwo.id)
        success.should eq(true)
        checkagain, vote_again = Vote.record_vote(gTwo.id, sTwo.id)
        checkagain.should eq(false)
      end

      it"it doesn't allow gamer to vote for synonym that belongs to Keyword that he/she voted for one of its synonyms before" do
        failure, vote_instance = Vote.record_vote(g.id, s.id)
        failure.should eq(false)
      end
    end

    describe "get_unvoted_keywords" do
      it "get list of unvoted approved keywords of the specified size for certain user" do
            keywords_list_gamer_one = Vote.get_unvoted_keywords(g.id, 0, 2)
            keywords_list_gamer_one.should =~ []
            keywords_list_gamer_one_again = Vote.get_unvoted_keywords(g.id, 1, 2)
            keywords_list_gamer_one_again.length.should eq(1)
            keywords_list_gamer_two = Vote.get_unvoted_keywords(gTwo.id, 2, 2)
            keywords_list_gamer_two.length.should eq(2)
      end

      it "never returns a word this gamer voted on before" do
            keywords_list = Vote.get_unvoted_keywords(g.id, 2, 2)
            keywords_list.should_not include(k)
            keywords_list.should include (kTwo)
      end
    end
end