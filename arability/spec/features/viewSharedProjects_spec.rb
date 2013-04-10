require "spec_helper"
describe "Project" do
  let(:gamer1){
	  gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mohamedtamer92@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
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
  let(:developer1){
  	developer = Developer.new
  	developer.first_name = "Mohamed"
  	developer.last_name = "Tamer"
  	developer.gamer_id = gamer1.id 
  	developer.save
  	developer
  }
  let(:developer2){
    developer = Developer.new
  	developer.first_name = "Karim"
  	developer.last_name = "Tamer"
  	developer.gamer_id = gamer2.id 
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

  it "developer2 should see project that developer1 shared" do
    shared = SharedProject.new
    shared.developer_id = developer2.id
    shared.project_id = project.id
    shared.save
    visit root_path
    click_link I18n.t(:sign_in)
    fill_in 'gamer_email', :with => gamer2.email
    visit backend_home_path
    # page.should have_content(I18n.t(:projects_index_tab2))
    page.find("#projects_shared").click
    page.should have_content(project.name)
  end
end