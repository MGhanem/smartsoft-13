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
    gamer.save validate: false
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
    it "populates an array of projects" do
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
    it "should render the :import_csv view", timo2: true do
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

  describe "PUT #add_from_csv_keywords", timo2: true do
    it "should add keyword and synonym to project" do
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
        put :add_from_csv_keywords, words_ids: [word2.id|syn2.id], id: project2.id
      }.to change(PreferedSynonym,:count).by(1)
    end

    it "should not add keyword and synonym to project", timo2: true do
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

  #Kareem Ali tests

  let(:test_gamer){
    gamer = Gamer.new
    gamer.username = "kareem"
    gamer.country = "Egypt"
    gamer.education_level = "school"
    gamer.gender = "male"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "kareemali@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
  }

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

  let(:keyword_without_synonyms){
    keyword_without_synonyms = Keyword.new
    keyword_without_synonyms.name = "hide"
    keyword_without_synonyms.approved = true
    keyword_without_synonyms.is_english = true
    keyword_without_synonyms.save
    keyword_without_synonyms
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

  let(:developer){
    developer = Developer.new
    developer.gamer_id = test_gamer.id 
    developer.save
    developer
  }


  before(:each) do
    login_gamer (developer.gamer)
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
    post :add_word_inside_project, project_id: test_project.id, keyword: test_keyword.name, synonym_id: synonym2.id
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

  it "should return false for followed word", kareem: true do
    keyword_without_synonyms
    developer.follow(keyword_without_synonyms.id)
    get :test_followed_keyword, project_id: test_project.id, keyword: keyword_without_synonyms.name
    response.should render_template("projects/test_followed_keyword")
    response.should be_success
    developer.keyword_ids.include?(keyword_without_synonyms.id).should eq(true)
  end

  it "should return true for unfollowed word", kareem: true do
    keyword_without_synonyms
    get :test_followed_keyword, project_id: test_project.id, keyword: keyword_without_synonyms.name
    response.should render_template("projects/test_followed_keyword")
    developer.keyword_ids.include?(keyword_without_synonyms.id).should eq(false)    
  end

  it "should redirects to project view when follow a word", kareem: true do
    is_following = developer.keyword_ids.include?(keyword_without_synonyms.id).to_s
    get :follow_unfollow, project_id: test_project.id, is_followed: is_following, keyword_id: keyword_without_synonyms.id
    flash[:success].should eq("لقد تم متابعة هذه الكلمة: #{keyword_without_synonyms.name}") 
    response.should redirect_to project_path(test_project.id)
  end  

  it "should redirects to project view when unfollow a word", kareem: true do
    developer.follow(keyword_without_synonyms.id)
    is_following = developer.keyword_ids.include?(keyword_without_synonyms.id).to_s
    get :follow_unfollow, project_id: test_project.id, is_followed: is_following, keyword_id: keyword_without_synonyms.id
    flash[:success].should eq("لقد تم إلغاء متابعة هذه الكلمة: #{keyword_without_synonyms.name}")
    response.should redirect_to project_path(test_project.id)
  end  
end