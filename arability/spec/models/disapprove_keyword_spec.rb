#encoding: utf-8
require 'spec_helper'

describe "disapprove keyword in database" do
  let(:keyword){
  	keyword = Keyword.new
  	keyword.name = "test"
  	keyword.is_english = true
    keyword.approved = true
    keyword.save
    keyword
  }
  it "should disapprove keyword in the database" do
  	result = Keyword.disapprove_keyword(keyword.id)
  	result.should eq(true)
  end
  it "should find keyword before recording disapproval" do
  	result = Keyword.disapprove_keyword(keyword.id)
  	result.should eq(true)
    k = Keyword.find(keyword.id)
    expect(k.approved).to eq(false)
  end
  it "should not disapprove keyword not in database" do
  	result = Keyword.disapprove_keyword(2)
  	result.should eq(false)
    k = Keyword.exists?(2)
    expect(k).to eq(false)
  end
end



