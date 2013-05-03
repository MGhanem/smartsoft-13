#encoding: utf-8
require 'spec_helper'

describe "gamer suggestion" do
	let(:test_gamer){
		test_gamer = Gamer.new
        test_gamer.username = "kareem"
        test_gamer.country = "Egypt"
        test_gamer.education_level = "university"
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

	let(:test_keyword2){
		test_keyword = Keyword.new
		test_keyword.name = "hide"
		test_keyword.approved = true
		test_keyword.is_english = true
		test_keyword.save
		test_keyword
	}


	let(:test_keyword3){
		test_keyword = Keyword.new
		test_keyword.name = "run"
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
		synonym2.keyword_id = test_keyword.id
		synonym2.save
		synonym2
	}


	let(:synonym3){
		synonym3 = Synonym.new
		synonym3.name = "ترابيزة"
		synonym3.approved = true
		synonym3.keyword_id = test_keyword2.id
		synonym3.save
		synonym3
	}


	let(:synonym4){
		synonym4 = Synonym.new
		synonym4.name = "ترابيزة"
		synonym4.approved = true
		synonym4.keyword_id = test_keyword3.id
		synonym4.save
		synonym4
	}

	before(:each) do
		test_gamer
		test_keyword
		test_keyword2
		test_keyword3
		synonym1
		synonym2
		synonym3
		synonym4
	end

	it "should not save a blank as suggested synonym", kareem: true do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("",keyword_id,nil)
		result.should eq(1)
	end

	it "should not save a blank as suggested synonym even with choosen formality", kareem: true do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("",keyword_id, true)
		result.should eq(1)
	end

	it "should not save a suggested synonym written in english even with choosen formality", kareem: true do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("car",keyword_id, false)
		result.should eq(3)
	end


	it "should save a suggested synonym if written in arabic and if choosen formality", kareem: true do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("بسيطذ", keyword_id, true)
		result.should eq(0)
	end

	it "should not save a suggested synonym without choosen formality even if in arabic", kareem: true do
		keyword_id = test_keyword.id
		result = test_gamer.suggest_synonym("شيسبيييس", keyword_id, nil)
		result.should eq(4)
	end

	it "should save a synonym with formality", kareem: true do
		keyword_id = test_keyword.id
		result = Synonym.record_suggested_synonym("يذطسذظ", keyword_id, false)
		result.should eq(0)
	end
end