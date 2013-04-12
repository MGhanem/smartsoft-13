#encoding: UTF-8
require "spec_helper"

describe "RecordSynonymTest_Omar" do

    let(:word) {word = Keyword.new
    word.name = "testkeyword"
    word.save
    word
    }


  it "should return false since the synonym is empty" do
    id = word.id
    result = Synonym.record_synonym("",id)
    expect(result).to eq (false)
  end

    it "should return false for the seconde synonym because it's a duplicates" do
    id = word.id
    result = Synonym.record_synonym("معنى",id)
    result2 = Synonym.record_synonym("معنى",id)
    expect(result).to eq (true)
    expect(result2).to eq (false)
  end

    it "should return false since there is no such keyword" do
    result = Synonym.record_synonym("ليس",1000)
    expect(result).to eq (false)
  end

    it "should return false since the synonym is not in arabic" do
    id = word.id
    result = Synonym.record_synonym("test",id)
    expect(result).to eq (false)
  end

    it "should return true since all conditions are met" do
    id = word.id
    result = Synonym.record_synonym("عربية",id)
    expect(result).to eq (true)
  end
end