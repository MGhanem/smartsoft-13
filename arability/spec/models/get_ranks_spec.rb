#encoding: utf-8
require 'spec_helper'

describe "retrieve gamer rank according to the list displayed" do
	let(:current_gamer){
    current_gamer = Gamer.new
    current_gamer.username = "Test"
    current_gamer.country = "Egypt"
    current_gamer.education_level = "high"
    current_gamer.gender = "female"
    current_gamer.date_of_birth = 1993-03-23
    current_gamer.email = "test@gmail.com"
    current_gamer.password = "1234567"
    current_gamer.highest_score = 5
    current_gamer.save
    current_gamer
  }

	it "should return gamer rank within arability gamers" do
    current_gamer
		rank = Gamer.get_gamer_rank(current_gamer)
		rank.should eq(nil)
	end

  it "should return gamer rank within facebook friends registered in arability" do
    current_gamer
    rank = Gamer.get_facebook_rank(current_gamer)
    rank.should eq(nil)
  end

  it "should return gamer rank within twitter friends registered in arability" do
    current_gamer
    rank = Gamer.get_twitter_rank(current_gamer)
    rank.should eq(nil)
  end

end