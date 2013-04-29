#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include Warden::Test::Helpers
include RequestHelpers

describe ProjectsController do
  include Devise::TestHelpers

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


  #Salma's Tests
  describe "GET #new" do
    it "initializes a new project" do
      a = create_logged_in_developer
      sign_in(a.gamer)
      get :new
    end
  end

describe "GET #create" do
  context "with valid attributes" do
    it "assigns attributes to the new project" do
      expect{
        project :create
      }
   end

    it "redirects to the project index" do
      project
      post :create, project: project
      response.should redirect_to Project.index
    end
  end

  context "with invalid attributes" do
    it "does not save the new project" do
      expect{
        project
        post :create, project: project
      }.to_not change(Project,:count)
    end

    it "re-renders the new method" do
      post :create, project: Factory.attributes_for(:invalid_project)
      response.should render_template :new
    end
  end
end

describe "GET #edit" do
  it "assigns the requested project to @project" do
    project
    get :edit, id: project
    assigns(:project).should eq(project)
  end
end

describe 'PUT update' do
  before :each do
    @project = Factory(:project, name: "Pro", minAge:"23", maxAge:"50")
  end

  context "valid attributes" do
    it "located the requested @project" do
      project
      put :update, id: @project, project: project
      assigns(:project).should eq(@project)
    end

    it "changes @project's attributes" do
      put :update, id: @project,
        project: Factory.attributes_for(:project, name: "Pro", minAge:"23", maxAge:"50")
      @project.reload
      @project.name.should eq("Pro")
      @project.minAge.should eq("23")
      @project.maxAge.should eq("50")
    end

    it "redirects to the project index" do
      project
      put :update, id: @project, project: project
      response.should redirect_to projects_path
    end
  end

  context "invalid attributes" do
    it "locates the requested @project" do
      put :update, id: @project, project: Factory.attributes_for(:invalid_project)
      assigns(:project).should eq(@project)
    end

    it "does not change @project's attributes" do
      put :update, id: @project,
        project: Factory.attributes_for(:project, name: "Pro", minAge: "23", maxAge:nil)
      @project.reload
      @project.name.should_not eq("Pro")
      @project.minAge.should_not eq("23")
      @project.minAge.should eq("50")
    end

    it "re-renders the edit method" do
      put :update, id: @project, project: Factory.attributes_for(:invalid_project)
      response.should render_template :edit
    end
  end

  it "should make developer remove a project shared with him" do
    sign_in gamer1
    get :remove_project_from_developer, :dev_id => developer1.id, :project_id => project.id
    #response.should be_success
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