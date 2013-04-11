#encoding: UTF-8
require "spec_helper"

describe "KeywordSynonymTests_mostafa" do

    let(:word) {word = Keyword.new
    word.name = "testkeyword"
    word.save
    word
    }
    let(:word2) {word = Keyword.new
    word.name = "testkeywordtwo"
    word.save
    word
    }
    let(:syn) { syn = Synonym.new
    syn.name = "كلمة"
    syn.keyword_id = word.id
    syn.save
    syn
    }
    let(:syn1) { syn = Synonym.new
    syn.name = "كلمتىن"
    syn.keyword_id = word.id
    syn.save
    syn
    }
    let(:syn2) { syn = Synonym.new
    syn.name = "ءكلمة"
    syn.keyword_id = word2.id
    syn.save
    syn
    }
    let(:syn3) { syn = Synonym.new
    syn.name = "سكلمتىن"
    syn.keyword_id = word2.id
    syn.save
    syn
    }

    let(:gamer1){ gamer = Gamer.new
    gamer.username = "Mostafa"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "male"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mer92@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
    }

    let(:gamer2){ gamer = Gamer.new
    gamer.username = "Hassaan"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "male"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mer92w@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
    }
    


  it "should return the keyword with an unapproved synonym only" do
    syn.approved = true
    syn.save
    syn1.approved = true
    syn1.save
    syn2.approved = false
    syn2.save
    syn3.approved = false
    syn3.save
    result = Keyword.words_with_unapproved_synonyms
    expect(result.first.name).to eq ("testkeywordtwo")
  end

  it "should return an array of Keywords with unpproved synonyms" do
    syn.approved = true
    syn.save
    syn1.approved = false
    syn1.save
    syn2.approved = true
    syn2.save
    syn3.approved = false
    syn3.save
    result1 = Keyword.words_with_unapproved_synonyms.first.name
    result2 = Keyword.words_with_unapproved_synonyms.second.name
    expect(result1).to eq ("testkeyword")
    expect(result2).to eq ("testkeywordtwo")
  end

  it "should return an empty array because no synonyms are approved" do
    syn.approved = true
    syn.save
    syn1.approved = true
    syn1.save
    syn2.approved = true
    syn2.save
    syn3.approved = true
    syn3.save
    result = Keyword.words_with_unapproved_synonyms
    expect(result).to eq ([])
  end

  it "Should return the highest voted Synonym" do
    syn.approved = true
    syn.save
    syn1.approved = true
    syn1.save
    Vote.record_vote(1, syn.id)
    Vote.record_vote(2, syn.id)
    result = Keyword.highest_voted_synonym(word).name
    expect(result).to eq (syn.name)
  end

  it "Should return an empty array because no synonyms have been voted" do
    syn.approved = true
    syn.save
    syn1.approved = true
    syn1.save
    result = Keyword.words_with_unapproved_synonyms
    expect(result).to eq ([])
  end
end