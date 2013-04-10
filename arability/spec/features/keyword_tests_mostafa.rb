#encoding UTF-8
require "spec_helper"

describe "KeywordSynonymTests_mostafa" do
  before :each do
    # @gamer
    @word = Keyword.new
    @word.name = "testkeyword"
    @word.save

    @word2 = Keyword.new
    @word2.name = "testkeyword"
    @word2.save

    @syn = Synonym.new
    @syn.name = "كلمة"
    @syn.keyword_id = @word.id
    @syn.save

    @syn2 = Synonym.new
    @syn2.name = "كلمتىن"
    @syn2.keyword_id = @word.id
    @syn2.save

    @syn3 = Synonym.new
    @syn3.name = "ءكلمة"
    @syn3.keyword_id = @word2.id
    @syn3.save

    @syn3 = Synonym.new
    @syn3.name = "سكلمتىن"
    @syn3.keyword_id = @word2.id
    @syn3.save
  end

  it "should return the keyword with an unapproved synonym only" do
    @syn.approved = true
    @syn.save
    @syn1.approved - true
    @syn1.save
    @syn2.approved - false
    @syn2.save
    @syn3.approved - false
    @syn3.save
    result = Keyword.words_with_unapproved_synonyms
    expect(result).to eq ([@word2])
  end

  it "should return an array of Keywords with unpproved synonyms" do
    @syn.approved = true
    @syn.save
    @syn1.approved - false
    @syn1.save
    @syn2.approved - true
    @syn2.save
    @syn3.approved - false
    @syn3.save
    result = Keyword.words_with_unapproved_synonyms
    expect(result).to eq ([@word, @words2])
  end

  it "should return an empty array because no synonyms are approved" do
    @syn.approved = true
    @syn.save
    @syn1.approved - true
    @syn1.save
    @syn2.approved - true
    @syn2.save
    @syn3.approved - true
    @syn3.save
    result = Keyword.words_with_unapproved_synonyms
    expect(result).to eq ([])
  end

  it "Should return the highest voted Synonym" do
    @syn.approved = true
    @syn.save
    @syn1.approved - true
    @syn1.save
    Vote.record_vote(1, @syn.id)
    Vote.record_vote(1, @syn.id)
    result = Keyword.highest_voted_synonym(@word.id)
    expect(result).to eq (@syn)
  end

  it "Should return an empty array because no synonyms have been voted" do
    @syn.approved = true
    @syn.save
    @syn1.approved - true
    @syn1.save
    result = Keyword.words_with_unapproved_synonyms
    expect(result).to eq ([])
  end
end