#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers
include Devise::TestHelpers

describe ProjectsController, type: :controller do

  let(:gamer1){
	  gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mohamedtamer5@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
  }

  let(:developer1){
  	developer = Developer.new
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

  let(:word) {
    word = Keyword.new
    word.name = "testkeyword"
    word.save
    word
  }

  let(:syn) { syn = Synonym.new
    syn.name = "كلمة"
    syn.keyword_id = word.id
    syn.save
    syn
  }

  it "a developer can open the link of import of one of his projects" do
    sign_in developer1.gamer
    get :import_csv, :project_id => project.id
    page.should have_content(I18n.t(:import_csv_title))
  end

  #khloud's tests

  it "redirects to project path after calling export_to_csv if project empty" do
    p = create_project
    get :export_to_csv, project_id: p.id
    response.should redirect_to project_path(p.id)
  end

  it "redirects to project path after calling export_to_xml if project empty" do
    p = create_project
    get :export_to_xml, project_id: p.id
    response.should redirect_to project_path(p.id)
  end

  it "redirectsto project path after calling export_to_json if project empty" do
    p = create_project
    get :export_to_json, project_id: p.id
    response.should redirect_to project_path(p.id)
  end

  it "responds with ok code after calling export_to_csv with valid project" do
    p = create_project
    ps = 
    PreferedSynonym.add_keyword_and_synonym_to_project(syn.id, word.id, p.id)
    get :export_to_csv, project_id: p.id
    response.code.should eq("200")
  end

  it "responds with ok code after calling export_to_xml with valid project" do
    p = create_project
    ps = 
    PreferedSynonym.add_keyword_and_synonym_to_project(syn.id, word.id, p.id)
    get :export_to_xml, project_id: p.id
    response.code.should eq("200")
  end

  it "responds with ok code after calling export_to_json with valid project" do
    p = create_project
    ps = 
    PreferedSynonym.add_keyword_and_synonym_to_project(syn.id, word.id, p.id)
    get :export_to_json, project_id: p.id
    response.code.should eq("200")
  end

  #Kareem Ali tests

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

  let(:test_project){
    project = Project.new
    project.name = "test"
    project.formal = true
    project.minAge = 10
    project.maxAge = 90
    project.owner_id = developer1.id
    project.description = "this is a test project" 
    project.save
    project
  }

  let(:prefered_synonym){
    prefered_synonym = PreferedSynonym.new
    prefered_synonym.project_id = test_project.id
    prefered_synonym.keyword_id = word.id
    prefered_synonym.synonym_id = syn.id
    prefered_synonym.save
    prefered_synonym
  }

  it "should add a keyword and a prefered synonym in a project and redirects to project view", kareem:true do
    developer = create_logged_in_developer
    sign_in(developer.gamer)
    post :quick_add, project_id: project.id, keyword: word.name, synonym_id: syn.id
    prefered_synonyms = PreferedSynonym.where(project_id: project.id)
    saved_prefered_synonym = prefered_synonyms.where(keyword_id: word.id).first
    saved_prefered_synonym.synonym_id.should eq(syn.id)
    response.should redirect_to project_path(project.id)
  end

  it "should add new synonym to an existing keyword if keyword added again and redirects to project view", kareem:true do
    developer = create_logged_in_developer
    sign_in(developer.gamer) 
    post :quick_add, project_id: test_project.id, keyword: word.name, synonym_id: synonym1.id
    prefered_synonyms = PreferedSynonym.where(project_id: test_project.id)
    saved_prefered_synonym = prefered_synonyms.where(keyword_id: word.id).first
    prefered_synonyms.count.should eq(1)
    saved_prefered_synonym.synonym_id.should eq(synonym1.id)
    response.should redirect_to project_path(test_project.id)
  end


end