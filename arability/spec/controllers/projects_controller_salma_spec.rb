#Salma's Tests
#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include Warden::Test::Helpers
include RequestHelpers
include Devise::TestHelpers

describe ProjectsController, type: :controller do

  let(:developer){
    developer = Developer.new
    developer.gamer_id = 1
    developer.save validate: false
    developer
  }

  let(:project){
    project = Project.new
    project.name = "banking"
    project.minAge = 19
    project.maxAge = 25
    project.owner_id = developer.id
    project.save
    project
  }

let(:cat){
  cat = Category.new
  cat.id = "13"
  cat.english_name = "Music"
  cat.arabic_name = "hey"
  cat.save validate: false
  cat
}

let(:s) {
  s = Synonym.new
  s.name = "hello"
  s.approved = true
  s.save validate: false
  s
}

  let(:keyword1){
  keyword1 = Keyword.new
  keyword1.name = "Art"
  keyword1.synonyms = [s]
  keyword1.categories = [cat]
  keyword1.approved = "true"
  keyword1.save validate: false
  keyword1
}

  before (:each) do
    developer
    cat
    project
    keyword1
    s
  end

  it "assigns the requested project to project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    get :edit, id: project
    assigns(:project).should eq(project)
  end

  it "located the requested project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    put :update, id: project.id, project: { name: "hospital", category:"" }
    assigns(:project).should eq(project)
  end

  it "changes project's attributes" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    put :update, id: project,
    project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    project.reload
    project.name.should eq("Pro")
    project.minAge.should eq(23)
    project.maxAge.should eq(50)
  end

  it "redirects to the project index" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    put :update, id: project, project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    response.should redirect_to projects_path
  end

  it "locates the requested project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    put :update, id: project, project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    assigns(:project).should eq(project)
  end

  it "does not change project's attributes" do
   a = create_logged_in_developer
   sign_in(a.gamer)
   put :update, id: project,
   project: { name: "Pro", minAge:"500", maxAge:"50",category:"" }
   project.reload
   project.name.should_not eq("Pro")
   project.minAge.should_not eq(500)
   project.minAge.should eq(19)
 end

 it "re-renders the edit method" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  put :update, id: project, project: { name: "Pro", minAge:"500", maxAge:"50",category:"" }
  response.should render_template :edit
end

it "renders the #show view" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  get :show, id: project
  response.should render_template project
end

it "views recommended words" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  get :view_recommended_words, project_id: project
  response.code.should eq("200")
end

it "gets recommended words" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  get :get_recommended_words, project_id: project.id, synonyms: { "1" => "1" }
  response.code.should redirect_to project_path(project.id)
end
end