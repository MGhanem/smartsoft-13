require "spec_helper"
include Warden::Test::Helpers

describe "Project" do
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
  	developer.first_name = "Mohamed"
  	developer.last_name = "Tamer"
  	developer.gamer_id = gamer1.id 
  	developer.save
  	developer
  }

  let(:gamer2){
    gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mohamedtamer@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
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

  it "gamer2 should not see projects because he is not registered as a developer" do
    login_as gamer2
    visit backend_home_path
    page.should have_content("Register")
  end
  
  it "a not signed-in user should not see projects page" do
    visit backend_home_path
    page.should have_content(I18n.t(:sign_in))
  end
  
  it "a signed in gamer registered as a developer should see his projects" do
    login_as gamer1
    visit backend_home_path
    page.should have_content(project.name)
  end
end
