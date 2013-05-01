#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers
include RequestHelpers

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

end

  # khloud's tests

  it "should delete a project" do
    sign_in gamer1
    put :destroy, id: project.id
    response.code.should eq("302")
  end

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
    test_keyword.name = "desk"
    test_keyword.approved = true
    test_keyword.is_english = true
    test_keyword.save
    test_keyword
  }

  let(:test_keyword2){
    test_keyword = Keyword.new
    test_keyword.name = "download"
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
    prefered_synonym.keyword_id = test_keyword.id
    prefered_synonym.synonym_id = synonym1.id
    prefered_synonym.save
    prefered_synonym
  }

  let(:category){
    category = Category.new
    category.english_name = "bank"
    category.arabic_name =  "بنك"
    category.save
    category
  }

  before(:each) do
    developer = create_logged_in_developer
    sign_in(developer.gamer)
    test_keyword
    synonym1
    synonym2
    test_keyword2
    test_project
    prefered_synonym
    category
  end

  it "should add a keyword and a prefered synonym in a project and redirects to project view", kareem: true do
    post :add_word_inside_project, project_id: project.id, keyword: word.name, synonym_id: syn.id
    prefered_synonyms = PreferedSynonym.where(project_id: project.id)
    saved_prefered_synonym = prefered_synonyms.where(keyword_id: word.id).first
    saved_prefered_synonym.synonym_id.should eq(syn.id)
    response.should redirect_to project_path(project.id)
  end

  it "should redirects to project view when new synonym to an existing keyword",
   kareem:true do
    post :quick_add, project_id: test_project.id, keyword: test_keyword.name, synonym_id: synonym2.id
    prefered_synonyms = PreferedSynonym.where(project_id: test_project.id)
    saved_prefered_synonym = prefered_synonyms.where(keyword_id: test_keyword.id).first
    response.should redirect_to project_path(test_project.id)
  end

  it "should change synonym to an existing keyword and redirects to project view",
   kareem:true do
    post :add_word_inside_project, project_id: test_project.id,
    keyword: test_keyword.name, synonym_id: synonym2.id
    prefered_synonyms = PreferedSynonym.where(project_id: test_project.id)
    saved_prefered_synonym = prefered_synonyms.where(keyword_id: test_keyword.id).first
    saved_prefered_synonym.synonym_id.should eq(synonym2.id)
    prefered_synonyms.count.should eq(1)
    response.should redirect_to project_path(test_project.id)
  end

  it "should render load_synonym.js file and succeed", kareem: true do
    post :load_synonyms, project_id: test_project.id, word: test_keyword.name
    response.should render_template("projects/load_synonyms.js")
    response.should be_success
  end

  it "shoud succed on sending a keyword for autocomplete", kareem: true do
    post :project_keyword_autocomplete, keyword_search:"d", project_id: test_project.id
    test_project.categories << category
    test_keyword.categories << category
    similar_keyword = [test_keyword.name, test_keyword2.name, 2]
    response.body.should == similar_keyword.to_json
    response.should be_success
  end

end