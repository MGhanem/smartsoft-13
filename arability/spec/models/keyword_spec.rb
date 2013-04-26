#encoding: UTF-8
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

  it "should add two word keywords" do
    success, keyword = Keyword.add_keyword_to_database("test testing")
    success.should eq(true)
    keyword.name.should eq("test testing")
    success, keyword = Keyword.add_keyword_to_database("ينسب ينسب")
    success.should eq(true)
    keyword.name.should eq("ينسب ينسب")
  end

  it "should add two word keywords without spaces in between" do
    success, keyword = Keyword.add_keyword_to_database("   test     testing   ")
    success.should eq(true)
    keyword.name.should eq("test testing")
    success, keyword = Keyword.add_keyword_to_database("  ينسب     ينسب  ")
    success.should eq(true)
    keyword.name.should eq("ينسب ينسب")
  end

  it "should add keywords with categories" do
    success, category = Category.add_category_to_database_if_not_exists("test", "تشتبت")
    success, keyword = Keyword.add_keyword_to_database("test", true, true, ["تشتبت"])
    success.should eq(true)
    category.keywords.include?(keyword).should eq(true)
    success, keyword = Keyword.add_keyword_to_database("ينسب", true, false, ["تشتبت"])
    success.should eq(true)
    category.keywords.include?(keyword).should eq(true)
  end
  it "should add keywords approved and unapproved" do
    success, keyword = Keyword.add_keyword_to_database("test", true)
    success.should eq(true)
    keyword.approved.should eq(true)
    success, keyword = Keyword.add_keyword_to_database("ينسب", false)
    success.should eq(true)
    keyword.approved.should eq(false)
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

	it "should return an empty list for an empty search keyword" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("")
		keyword.should eq([])
	end

	it "should return one matching keyword for the passed param in english" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("clickme")
		keyword.first.name.should eq("clickMe")
		keyword = Keyword.get_similar_keywords("clickme   ")
		keyword.first.name.should eq("clickMe")
	end

	it "should return two matching keywords for the passed param in english sorted by relevance" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("click")
		keyword.first.name.should eq("click")
		keyword.last.name.should eq("clickMe")
	end

	it "should return an empty list when searching for an unapproved keyword" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("click me")
		keyword.should eq([])
	end

	it "should return an empty list for a search keyword in english and not in the db" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("nourhan")
		keyword.should eq([])
	end

		it "should return one matching keyword for the passed param in arabic" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("ابتث")
		keyword.first.name.should eq("ابتث")
	end

	it "should return two matching keywords for the passed param in arabic sorted by relevance" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("ابت")
		keyword.first.name.should eq("ابت")
		keyword.last.name.should eq("ابتث")
	end

	it "should return an empty list for a search keyword in arabic and not in the db" do
		Keyword.create(name: "click", approved: true)
		Keyword.create(name: "clickMe", approved: true)
		Keyword.create(name: "click me")
		Keyword.create(name: "ابت", approved: true)
		Keyword.create(name: "ابتث", approved: true)
		keyword = Keyword.get_similar_keywords("ضصثق")
		keyword.should eq([])
	end

	it "should return an empty list if no synonyms were found without filters" do
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", approved: true)
		synonyms, votes = keyword.retrieve_synonyms
		synonyms.should eq([])
		votes.should eq({})
	end

	it "should return an empty list if synonyms are unapproved" do
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id)
		synonyms, votes = keyword.retrieve_synonyms
		synonyms.should eq([])
		votes.should eq({})
	end

	it "should return an empty list if keyword is unapproved" do
		keyword = Keyword.create(name: "click")
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		synonyms, votes = keyword.retrieve_synonyms
		synonyms.should eq([])
		votes.should eq({})
	end

	it "should return an empty list of votes if synonym has no votes" do
		gamer = Gamer.new
		gamer.username = "Nourhan"
		gamer.country = "Egypt"
		gamer.education_level = "high"
		gamer.gender = "female"
		gamer.date_of_birth = "1993-03-23"
		gamer.email = "nour@gmail.com"
		gamer.password = "1234567"
		gamer.save(validate: false)
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		synonyms, votes = keyword.retrieve_synonyms
		synonyms.first.name.should eq("انقر")
		votes.should eq({})
	end

	it "should return approved synonyms and votes of approved keywords" do
		gamer = Gamer.new
		gamer.username = "Nourhan"
		gamer.country = "Egypt"
		gamer.education_level = "high"
		gamer.gender = "female"
		gamer.date_of_birth = "1993-03-23"
		gamer.email = "nour@gmail.com"
		gamer.password = "1234567"
		gamer.save(validate: false)
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		Vote.record_vote(gamer.id, synonym.id)
		synonyms, votes = keyword.retrieve_synonyms
		synonyms.first.name.should eq("انقر")
		votes[synonym.id].should eq(1)
	end

	it "should return votes according to country filter if applied" do
		gamer = Gamer.new
		gamer.username = "Nourhan"
		gamer.country = "Egypt"
		gamer.education_level = "high"
		gamer.gender = "female"
		gamer.date_of_birth = "1993-03-23"
		gamer.email = "nour@gmail.com"
		gamer.password = "1234567"
		gamer.save(validate: false)
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		Vote.record_vote(gamer.id, synonym.id)
		synonyms, votes = keyword.retrieve_synonyms("saudi arabia")
		synonyms.first.name.should eq("انقر")
		votes.should eq({})
		synonyms, votes = keyword.retrieve_synonyms("egypt")
		votes[synonym.id].should eq(1)
	end

	it "should return votes according to age range filter if applied" do
		gamer = Gamer.new
		gamer.username = "Nourhan"
		gamer.country = "Egypt"
		gamer.education_level = "high"
		gamer.gender = "female"
		gamer.date_of_birth = "1993-03-23"
		gamer.email = "nour@gmail.com"
		gamer.password = "1234567"
		gamer.save(validate: false)
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		Vote.record_vote(gamer.id, synonym.id)
		synonyms, votes = keyword.retrieve_synonyms(nil, 10, 11)
		synonyms.first.name.should eq("انقر")
		votes.should eq({})
		synonyms, votes = keyword.retrieve_synonyms(nil, 10, 11)
		votes.should eq({})
		synonyms, votes = keyword.retrieve_synonyms(nil, 10, 30)
		votes[synonym.id].should eq(1)
		synonyms, votes = keyword.retrieve_synonyms(nil, nil, 30)
		votes[synonym.id].should eq(1)
		synonyms, votes = keyword.retrieve_synonyms(nil, 10, nil)
		votes[synonym.id].should eq(1)
	end

	it "should return votes according to gender filter if applied" do
		gamer = Gamer.new
		gamer.username = "Nourhan"
		gamer.country = "Egypt"
		gamer.education_level = "high"
		gamer.gender = "female"
		gamer.date_of_birth = "1993-03-23"
		gamer.email = "nour@gmail.com"
		gamer.password = "1234567"
		gamer.save(validate: false)
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		Vote.record_vote(gamer.id, synonym.id)
		synonyms, votes = keyword.retrieve_synonyms(nil, nil, nil, "female")
		synonyms.first.name.should eq("انقر")
		votes[synonym.id].should eq(1)
		synonyms, votes = keyword.retrieve_synonyms(nil, nil, nil, "male")
		votes.should eq({})
	end

		it "should return votes according to education_level filter if applied" do
		gamer = Gamer.new
		gamer.username = "Nourhan"
		gamer.country = "Egypt"
		gamer.education_level = "high"
		gamer.gender = "female"
		gamer.date_of_birth = "1993-03-23"
		gamer.email = "nour@gmail.com"
		gamer.password = "1234567"
		gamer.save(validate: false)
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		Vote.record_vote(gamer.id, synonym.id)
		synonyms, votes = keyword.retrieve_synonyms(nil, nil, nil, nil, "high")
		synonyms.first.name.should eq("انقر")
		votes[synonym.id].should eq(1)
		synonyms, votes = keyword.retrieve_synonyms(nil, nil, nil, nil, "low")
		votes.should eq({})
	end

	it "should return approved synonyms sorted according to votes" do
		gamer = Gamer.new
		gamer.username = "Nourhan"
		gamer.country = "Egypt"
		gamer.education_level = "high"
		gamer.gender = "female"
		gamer.date_of_birth = "1993-03-23"
		gamer.email = "nour@gmail.com"
		gamer.password = "1234567"
		gamer.save(validate: false)
		keyword = Keyword.create(name: "click", approved: true)
		synonym = Synonym.create(name: "انقر", keyword_id: keyword.id, approved: true)
		synonym2 = Synonym.create(name: "دوس", keyword_id: keyword.id, approved: true)
		Vote.record_vote(gamer.id, synonym.id)
		synonyms, votes = keyword.retrieve_synonyms
		synonyms.first.name.should eq("انقر")
		synonyms.last.name.should eq("دوس")
	end

end
