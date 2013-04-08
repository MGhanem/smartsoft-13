#encoding: utf-8
require 'spec_helper'

describe Keyword do
  it "Adds keyword to database" do
    success, keyword = Keyword.add_keyword_to_database("test")
    success.should eq(true)
    success, keyword = Keyword.add_keyword_to_database("ينسب")
    success.should eq(true)
  end
  it "Doesnt add keyword to database if english and arabic letters" do
    success, keyword = Keyword.add_keyword_to_database("ينسب dj")
    success.should eq(false)
  end
  it "Doesnt add keyword to database if anything other than letters" do
    success, keyword = Keyword.add_keyword_to_database("test2")
    success.should eq(false)
    success, keyword = Keyword.add_keyword_to_database("ستمب2")
    success.should eq(false)
  end
  it "should strip keyword before adding to database" do
    success, keyword = Keyword.add_keyword_to_database("test ")
    success.should eq(true)
    keyword.name.should eq("test")
    success, keyword = Keyword.add_keyword_to_database("ينسب ")
    success.should eq(true)
    keyword.name.should eq("ينسب")
  end
  it "should downcase keyword before adding to database" do
    success, keyword = Keyword.add_keyword_to_database("Dj")
    success.should eq(true)
    keyword.name.should eq("dj")
  end
  it "should find keyword by name" do
    success, keyword = Keyword.add_keyword_to_database("dj")
    success.should eq(true)
    keyword2 = Keyword.find_by_name("dj")
    keyword2.id.should eq(keyword.id)
  end
end
