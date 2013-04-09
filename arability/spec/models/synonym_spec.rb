require 'spec_helper'

describe Synonym do 

  describe "get_visual_stats_gender" do 

  it "returns the genders of voters and correponding percenteges of voters belong to each gender" do

   s = Factory(:synonym)
   g = Factory(:gamer)
   s_id = s.id
   g_id = g.id
   Factory.create(:vote, synonym_id: s_id, gamer_id: g_id)
   s.get_visual_stats_gender.should == [["male", 100]]
  end

  it "returns an empty list when the synonym has no votes" do

   s = Factory(:synonym)
   s.get_visual_stats_gender.should == []
  end

  end

   describe "get_visual_stats_country" do 

  it "returns the list of countries of voters and correponding percenteges of voters from each country" do

   s = Factory(:synonym)
   g = Factory(:gamer)
   s_id = s.id
   g_id = g.id
   Factory.create(:vote, synonym_id: s_id, gamer_id: g_id)
   s.get_visual_stats_country.should == [["Egypt", 100]]
  end

  it "returns an empty list when the synonym has no votes" do

   s = Factory(:synonym)
   s.get_visual_stats_country.should == []
  end

  end

   describe "get_visual_stats_age" do 

  it "returns the list of age groups of voters and correponding percenteges of voters from each age group" do

   s = Factory(:synonym)
   g = Factory(:gamer)
   s_id = s.id
   g_id = g.id
   Factory.create(:vote, synonym_id: s_id, gamer_id: g_id)
   s.get_visual_stats_age.should == [["10-25", 100]]
  end

  it "returns an empty list when the synonym has no votes" do

   s = Factory(:synonym)
   s.get_visual_stats_country.should == []
  end

  end

   describe "get_visual_stats_education" do 

  it "returns the list of education levels of voters and correponding percenteges of voters belong to each level" do

   s = Factory(:synonym)
   g = Factory(:gamer)
   s_id = s.id
   g_id = g.id
   Factory.create(:vote, synonym_id: s_id, gamer_id: g_id)
   s.get_visual_stats_education.should == [["low", 100]]
  end

  it "returns an empty list when the synonym has no votes" do

   s = Factory(:synonym)
   s.get_visual_stats_education.should == []
  end

  end
  
end