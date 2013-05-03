#encoding: utf-8
require 'spec_helper'

describe "gamer voting" do
	let(:test_gamer){
		test_gamer = Gamer.new
        test_gamer.username = "kareem"
        test_gamer.country = "Egypt"
        test_gamer.education_level = "high"
        test_gamer.gender = "male"
        test_gamer.date_of_birth = "1993-03-23"
        test_gamer.email = "kareem@gmail.com"
        test_gamer.password = "kareem"
        test_gamer.confirmed_at = Time.now
        test_gamer.save validate: false
        test_gamer
	}

	let(:test_keyword){
		test_keyword = Keyword.new
		test_keyword.name = "airplane"
		test_keyword.approved = true
		test_keyword.is_english = true
		test_keyword.save
		test_keyword
	}


	let(:test_keyword2){
		test_keyword = Keyword.new
		test_keyword.name = "airplane"
		test_keyword.approved = true
		test_keyword.is_english = true
		test_keyword.save
		test_keyword
	}

	let(:synonym1){
		synonym1 = Synonym.new
		synonym1.name = "ايربلان"
		synonym1.approved = true
		synonym1.keyword_id = test_keyword.id
		synonym1.save
		synonym1
	}

	let(:synonym2){
		synonym2 = Synonym.new
		synonym2.name = "طيارة"
		synonym2.approved = true
		synonym2.keyword_id = test_keyword2.id
		synonym2.save
		synonym2
	}


	it "should save a selected synonym when formality is true", kareem: true do
		result = test_gamer.select_synonym(synonym1.id, true)
		added_vote = Vote.where(synonym_id: synonym1.id)
		added_vote.count.should_not eq(0)
		result.should eq(true) 
	end

	it "should save a selected synonym when formality is false", kareem: true do
		result = test_gamer.select_synonym(synonym2.id, false)
		added_vote = Vote.where(synonym_id: synonym2.id)
		added_vote.count.should_not eq(0)
		result.should eq(true) 
	end
end