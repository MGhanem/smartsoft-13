#encoding: UTF-8
require 'spec-helper'
describe "Prefered Synonym" do
  let(:gamer1){
	  gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mohamedtamer92@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
  }

  let(:developer1){
  	developer = Developer.new
  	developer.first_name = "Mohamed"
  	developer.last_name = "Tamer"
  	developer.gamer_id = gamer1.id 
  	developer.save
  	developer
  }

  let(:project){
    project = Project.new
    project.name = "banking"
    project.minAge = 19
    project.maxAge = 25
    project.owner_id = developer1.id
    project.save
    project   
  }
  let(:word){
  	k = Keyword.new
  	k.name = "Hi"
  	k.save
  }
  let(:word1){
  	k = Keyword.new
  	k.name = "Hi"
  	k.save
  }

  let(:syno){
  	s = Synonym.new
  	s.name = "مرحبا"
  	s.keyword_id = word1.id
  	s.save
  }
  it "a word cannot be added to a project if the synonym doesn't belong to it" do
    result = PreferedSynonym.add_keyword_and_synonym_to_project(syno.id, word.id, project.id)
    except(result).to eq(false)
  end
  it "a word will be added to a project if the synonym belongs to it" do
    result = PreferedSynonym.add_keyword_and_synonym_to_project(syno.id, word1.id, project.id)
    except(result).to eq(true)
  end
end