#encoding:utf-8
require 'spec_helper'
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe ProjectsController,  type: :controller do
	include Devise::TestHelpers
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

	let(:test_developer){
		test_developer.gamer_id = test_gamer.id
		test_developer.verified = true
		test_developer.save
		test_developer
	}

	let(:project){
	  project = Project.new
	  project.name = "test"
	  project.formal = true
	  project.minAge = 10
	  project.maxAge = 90
	  project.owner_id = test_developer.id
	  project.description = "this is a test project" 
	  project.save
	  project
	}

	let(:test_keyword1){
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

	    let(:test_keyword2){
		test_keyword = Keyword.new
		test_keyword.name = "hide"
		test_keyword.approved = true
		test_keyword.is_english = true
		test_keyword.save
		test_keyword
	}

	let(:synonym3){
		synonym1 = Synonym.new
		synonym1.name = "استخبي"
		synonym1.approved = true
		synonym1.keyword_id = Keyword.where(name:"hide").first
		synonym1.save
		synonym1
	}

	let(:synonym4){
		synonym2 = Synonym.new
		synonym2.name = "ابحث"
		synonym2.approved = true
		synonym2.keyword_id = Keyword.where(name:"hide").first
		synonym2.save
		synonym2
	}

	let(:synonym5){
		synonym2 = Synonym.new
		synonym2.name = "اهرب"
		synonym2.approved = true
		synonym2.keyword_id = Keyword.where(name:"hide").first
		synonym2.save
		synonym2
	}


	it "should add a keyword and a prefered synonym in a project" do
        sign_in test_developer.gamer
		get :quick_add, project_id: project.id, keyword: test_keyword1.name, synonym_id: synonym1.id
		prefered_synonyms = PreferedSynonym.where(project_id: project.id)
		saved_prefered_synonym = prefered_synonyms.where(keyword_id: test_keyword1.id).first
		saved_prefered_synonym.synonym_id.should eq(synonym1.id)
	end
end