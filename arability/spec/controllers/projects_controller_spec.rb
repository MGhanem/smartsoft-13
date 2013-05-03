#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

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

  #Timo's tests
  describe "GET #index" do
    it "populates an array of projects", timo: true do
      a = create_logged_in_developer
      sign_in(a.gamer)
      project2 = Project.new
      project2.name = "banking"
      project2.minAge = 19
      project2.maxAge = 25
      project2.owner_id = (a.gamer).id
      project2.save validate: false
      get :index
      assigns(:my_projects).should eq([project2])
    end

    it "renders the :index view", timo: true do
      a = create_logged_in_developer
      sign_in(a.gamer)
      get :index
      response.should render_template :index
    end
  end

  describe "GET #import_csv" do
    it "should render the :import_csv view", timo: true do
      a = create_logged_in_developer
      sign_in(a.gamer)
      project2 = Project.new
      project2.name = "banking"
      project2.minAge = 19
      project2.maxAge = 25
      project2.owner_id = (a.gamer).id
      project2.save validate: false
      get :import_csv, id: project2.id
      response.should render_template :import_csv
    end
  end

  describe "PUT #add_from_csv_keywords", timo: true do
    
    it "should not add keyword and synonym to project", timo: true do
      a = create_logged_in_developer
      sign_in(a.gamer)
      project2 = Project.new
      project2.name = "banking"
      project2.minAge = 19
      project2.maxAge = 25
      project2.owner_id = (a.gamer).id
      project2.save validate: false
      word2 = Keyword.new
      word2.name = "testkeyword"
      word2.save validate: false
      syn2 = Synonym.new
      syn2.name = "كلمة"
      syn2.keyword_id = word.id
      syn2.save validate: false
      expect{
        put :add_from_csv_keywords, words_ids: [], id: project2.id
      }.to_not change(PreferedSynonym,:count)
    end
  end
  #End of Timo's tests


  # Noha's test
  it "should make developer remove a project shared with him" do
    sign_in gamer1
    get :remove_project_from_developer, dev_id: developer1.id, project_id: project.id
    response.code.should eq("302")
  end


  it "should delete a project" do
    sign_in gamer1
    put :destroy, id: project.id
    response.code.should eq("302")
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
end