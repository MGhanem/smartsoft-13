#encoding: utf-8
require 'spec_helper'

describe "gamer suggestion" do
	let(:test_gamer){
		test_gamer = Gamer.new
        test_gamer.username = "kareem"
        test_gamer.country = "Egypt"
        test_gamer.education_level = "high"
        test_gamer.gender = "male"
        test_gamer.date_of_birth = "1993-03-23"
        test_gamer.email = "kareem@gmail.com"
        test_gamer.password = "kareem"
        test_gamer.save
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

	let(:synonym1){
		synonym1 = Synonym.new
		synonym1.name = "ايربلان"
		synonym1.approved = true
		synonym1.keyword_id = Keyword.where(name:"airplane").first
		synonym1.save
		synonym1
	}

	let(:synonym2){
		synonym2 = Synonym.new
		synonym2.name = "طيارة"
		synonym2.approved = true
		synonym2.keyword_id = Keyword.where(name:"airplane").first
		synonym2.save
		synonym2
	}

	it "should not save a blank as suggested synonym" do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("",keyword_id)
		result.should eq(1)
	end

	it "should not save a suggested synonym written in english" do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("car",keyword_id)
		result.should eq(3)
	end


	it "should save a suggested synonym if written in arabic" do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("يبتنم",keyword_id)
		added_synonym =  Synonym.where(name: "يبتنم",keyword_id: keyword_id).first
		added_vote = Vote.where(keyword_id, added_synonym.id)
		result.should eq(0)
		added_vote.should_not eq(0) 
	end

end