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

  it "a developer can open the link of import of one of his projects" do
    sign_in developer1.gamer
    get :import_csv, :project_id => project.id
    page.should have_content(I18n.t(:import_csv_title))
  end
end