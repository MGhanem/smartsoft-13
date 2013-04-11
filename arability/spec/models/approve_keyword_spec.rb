#encoding: utf-8
require 'spec_helper'

describe "approve keyword in database" do
  let(:keyword){
  	keyword = Keyword.new
  	keyword.name = "test"
  	keyword.is_english = true
    keyword.save
    keyword
  }
  it "should approve keyword in the database" do
  	result = Keyword.approve_keyword(keyword.id)
  	result.should eq(true)
  end
  it "should find keyword before recording approval" do
  	result = Keyword.approve_keyword(keyword.id)
  	result.should eq(true)
    k = Keyword.find(keyword.id)
    expect(k.approved).to eq(true)
  end
  it "should not approve keyword not in database" do
  	result = Keyword.approve_keyword(2)
  	result.should eq(false)
    k = Keyword.exists?(2)
    expect(k).to eq(false)
  end
end



