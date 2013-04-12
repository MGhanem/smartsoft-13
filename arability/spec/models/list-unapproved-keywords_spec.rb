#encoding: UTF-8
require "spec_helper"

describe "ListUnapprovedKeywordsTest_Omar" do

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
    let(:word3) {word = Keyword.new
    word.name = "testkeywordthree"
    word.save
    word
    }
    let(:word4) {word = Keyword.new
    word.name = "testkeywordfour"
    word.save
    word
    }

    


  it "should return the unapproved keyword only" do
    word.approved = true
    word.save
    word2.approved = true
    word2.save
    word3.approved = true
    word3.save
    word4.approved = false
    word4.save
    result = Keyword.list_unapproved_keywords
    expect(result.first.name).to eq ("testkeywordfour")
  end

  it "should return an array of Keywords with unpproved synonyms" do
    word.approved = true
    word.save
    word2.approved = false
    word2.save
    word3.approved = true
    word3.save
    word4.approved = false
    word4.save
    result1 = Keyword.list_unapproved_keywords.first.name
    result2 = Keyword.list_unapproved_keywords.second.name
    expect(result1).to eq ("testkeywordtwo")
    expect(result2).to eq ("testkeywordfour")
  end

  it "should return an empty array because no synonyms are approved" do
    word.approved = true
    word.save
    word2.approved = true
    word2.save
    word3.approved = true
    word3.save
    word4.approved = true
    word4.save
    result = Keyword.list_unapproved_keywords
    expect(result).to eq ([])
  end
end