#Salma's Tests
#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include Warden::Test::Helpers
include RequestHelpers
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

let(:cat){
  cat = Category.new
  cat.id = "13"
  cat.english_name = "Music"
  cat.arabic_name = "hey"
  cat.save
  cat
}

  let(:keyword1){
  keyword1 = Keyword.new
  keyword1.name = "Art"
  keyword1.synonyms = [Synonym.create(name: "hey", keyword_id: keyword1.id, approved: true)]
  keyword1.categories = [cat]
  keyword1.approved = "true"
  keyword1.save
  keyword1
}
   let(:submodel){
    submodel = SubscriptionModel.new
    submodel.limit=50
    submodel.limit_search=50
    submodel.limit_follow=50
    submodel.limit_project=1
    submodel.save
    submodel
  }

  let(:my_sub){
    MySubscription.choose(developer1.id, submodel.id)
    puts "dev_id : #{developer1.id}"
    my_sub = MySubscription.where(:developer_id => developer1.id).first
    my_sub
  }

  it "initializes a new project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    get :new
    response.code.should eq("200")
  end

  it "assigns the requested project to project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    get :edit, id: project
    assigns(:project).should eq(project)
  end

  it "located the requested project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    put :update, id: project.id, project: { name: "hospital", category:"" }
    assigns(:project).should eq(project)
  end

  it "changes project's attributes" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
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
    project
    put :update, id: project, project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    response.should redirect_to projects_path
  end

  it "locates the requested project" do
    a = create_logged_in_developer
    sign_in(a.gamer)
    project
    put :update, id: project, project: { name: "Pro", minAge:"23", maxAge:"50",category:"" }
    assigns(:project).should eq(project)
  end

  it "does not change project's attributes" do
   a = create_logged_in_developer
   sign_in(a.gamer)
   project
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
  project
  put :update, id: project, project: { name: "Pro", minAge:"500", maxAge:"50",category:"" }
  response.should render_template :edit
end

it "renders the #show view" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  project
  get :show, id: project
  response.should render_template project
end

it "views recommended words" do
  a = create_logged_in_developer
  sign_in(a.gamer)
  project
  get :view_recommended_words, project_id: project
  response.code.should eq("200")
end

end