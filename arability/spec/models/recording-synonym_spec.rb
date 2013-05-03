#encoding: UTF-8
require "spec_helper"

describe "RecordSynonymTest" do

  let(:word) {
    word = Keyword.new
    word.name = "testkeyword"
    word.save
    word
  }

  it "should return false since the synonym is empty", omar: true do
    id = word.id
    result = Synonym.record_synonym("",id)
    expect(result).to eq (false)
  end

  it "should return false for the second synonym because it's a duplicate", omar: true do
    id = word.id
    result = Synonym.record_synonym("معنى",id)
    result2 = Synonym.record_synonym("معنى",id)
    expect(result).to eq (true)
    expect(result2).to eq (false)
  end

  it "should return false since there is no such keyword", omar: true do
    result = Synonym.record_synonym("ليس",1000)
    expect(result).to eq (false)
  end

  it "should return false since the synonym is not in arabic", omar: true do
    id = word.id
    result = Synonym.record_synonym("test",id)
    expect(result).to eq (false)
  end

  it "should return true and the new synonym model as full_output is true", omar: true do
    id = word.id
    result, synonym = Synonym.record_synonym("عربية",id,true)
    expect(result).to eq (true)
    expect(synonym.name).to eq ("عربية")
  end

  it "should return true and approved false as approved is false", omar: true do
    id = word.id
    result, synonym = Synonym.record_synonym("عربي",id,true,false)
    expect(result).to eq (true)
    expect(synonym.approved).to eq (false)
  end

  it "should return false and the new synonym model id as nil", omar: true do
    id = word.id
    result, synonym = Synonym.record_synonym("try",id,true)
    expect(result).to eq (false)
    expect(synonym.id).to eq (nil)
  end

  it "should set is_formal with the value entered", omar: true do
    id = word.id
    result, synonym = Synonym.record_synonym("عربي",id,true,false,false)
    expect(result).to eq (true)
    expect(synonym.is_formal).to eq (false)
  end

  it "should set is_formal with nil as there is no value entered", omar: true do
    id = word.id
    result, synonym = Synonym.record_synonym("عربي",id,true,false)
    expect(result).to eq (true)
    expect(synonym.is_formal).to eq (nil)
  end

end