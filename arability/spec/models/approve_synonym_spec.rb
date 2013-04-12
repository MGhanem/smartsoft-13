#encoding: utf-8
require 'spec_helper'

describe "approve synonym in database" do
  let(:keyword){
    keyword = Keyword.new
    keyword.name = "test"
    keyword.is_english = true
    keyword.save
    keyword
  }
  let(:synonym){
  	synonym = Synonym.new
  	synonym.name = "تجربة"
  	synonym.keyword_id = keyword.id
    synonym.save
    synonym
  }
  it "should approve synonym in the database" do
  	result = Synonym.approve_synonym(synonym.id)
  	result.should eq(true)
  end
  it "should find synonym before recording approval" do
  	result = Synonym.approve_synonym(synonym.id)
  	result.should eq(true)
    k = Synonym.find(synonym.id)
    expect(k.approved).to eq(true)
  end
  it "should not approve synonym not in database" do
  	result = Synonym.approve_synonym(2)
  	result.should eq(false)
    k = Synonym.exists?(2)
    expect(k).to eq(false)
  end
end



