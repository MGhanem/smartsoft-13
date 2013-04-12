require "spec_helper"
include Warden::Test::Helpers

describe "Project" do
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

  it "a developer can open the link of import of one of his projects" do
    sign_in developer1.gamer
    visit backend_home_path
    visit project_path(locale => "en", project_id => project.id)
    visit import_csv_project
    page.should have_content(I18n.t(:import_csv_title))
  end
  it "a developer cannot import an empty file" do
    sign_in developer1.gamer
    visit backend_home_path
    visit project_path(project_id => project.id)
    visit import_csv_project
    visit choose_keywords_project_path
    page.should have_content(I18n.t(:import_csv_title))
  end
  it "a developer cannot import a non-csv file" do
    sign_in developer1.gamer
    visit backend_home_path
    visit project_path(project_id => project.id)
    visit import_csv_project
    visit choose_keywords_project_path
    file = File.new(Rails.root + 'app\controllers\vote.rb')
    visit choose_keywords_project_path    
    page.should have_content(I18n.t(:import_csv_title))
  end
  it "a developer can import a csv file and get redirected to choose keywords view" do
    sign_in developer1.gamer
    visit backend_home_path
    visit project_path(project_id => project.id)
    visit import_csv_project
    visit choose_keywords_project_path
    file = File.new('C:\Users\toshiba\Desktop\Book2.csv')
    visit choose_keywords_project_path
    page.should have_content(I18n.t(:choose_keyword_title))
  end
end