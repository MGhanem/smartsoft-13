require "spec_helper"
include Warden::Test::Helpers

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
  	# developer.first_name = "Mohamed"
  	# developer.last_name = "Tamer"
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

  it "a developer can open the link of import of one of his projects" do
    sign_in developer1.gamer
    get :import_csv, :project_id => project.id
    page.should have_content(I18n.t(:import_csv_title))
  end
end

describe "GET #new" do
  it "initializes a new project" do
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
      post :create, project: Factory.attributes_for(:project)
      response.should redirect_to Project.index
    end
  end

  context "with invalid attributes" do
    it "does not save the new project" do
      expect{
        post :create, project: Factory.attributes_for(:invalid_project)
      }.to_not change(Project,:count)
    end

    it "re-renders the new method" do
      post :create, project: Factory.attributes_for(:invalid_project)
      response.should render_template :new
    end
  end
end