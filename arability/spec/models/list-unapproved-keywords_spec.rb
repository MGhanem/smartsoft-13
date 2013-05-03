#encoding: UTF-8
require "spec_helper"

describe "ListUnapproved/Approved/ReportedKeywordsTest_Omar" do

  let(:word) {
    word = Keyword.new
    word.name = "testkeyword"
    word.save
    word
  }

  let(:word2) {
    word = Keyword.new
    word.name = "testkeywordtwo"
    word.save
    word
  }

  let(:word3) {
    word = Keyword.new
    word.name = "testkeywordthree"
    word.save
    word
  }

  let(:word4) {
    word = Keyword.new
    word.name = "testkeywordfour"
    word.save
    word
  }

    let(:gamer) {
      gamer = Gamer.new
      gamer.username = "Omar"
      gamer.country = "Egypt"
      gamer.gender = "male"
      gamer.date_of_birth = "1993-10-23"
      gamer.email = "omar@gmail.com"
      gamer.password = "1234567"
      gamer.education_level = "University"
      gamer.admin = true
      gamer.save validate: false
      gamer
    }

  let(:report1) {
    report = Report.new
    report.reported_word_id = word.id
    report.reported_word_type = "Keyword"
    report.gamer_id = gamer.id
    report.save
    report
  }

  it "should return the unapproved keyword only", omar: true do
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

  it "should return an array of Keywords with unpproved synonyms", omar: true do
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

  it "should return an empty array because no synonyms are unapproved", omar: true do
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

  it "should return the approved keyword only", omar: true do
    word.approved = false
    word.save
    word2.approved = false
    word2.save
    word3.approved = false
    word3.save
    word4.approved = true
    word4.save
    result = Keyword.list_approved_keywords
    expect(result.first.name).to eq ("testkeywordfour")
  end

  it "should return an array of Keywords with approved synonyms", omar: true do
    word.approved = true
    word.save
    word2.approved = false
    word2.save
    word3.approved = true
    word3.save
    word4.approved = false
    word4.save
    result1 = Keyword.list_approved_keywords.first.name
    result2 = Keyword.list_approved_keywords.second.name
    expect(result1).to eq ("testkeyword")
    expect(result2).to eq ("testkeywordthree")
  end

  it "should return an empty array because no synonyms are approved", omar: true do
    word.approved = false
    word.save
    word2.approved = false
    word2.save
    word3.approved = false
    word3.save
    word4.approved = false
    word4.save
    result = Keyword.list_approved_keywords
    expect(result).to eq ([])
  end

  it "should return a list of reported keywords", omar: true do
    report1
    result = Keyword.list_reported_keywords
    expect(result.first.name).to eq ("testkeyword")
  end

end