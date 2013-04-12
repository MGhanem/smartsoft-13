#encoding: UTF-8
require 'spec_helper'

describe "Create_Project" do
	let (:gamer) {
		gamer = Gamer.new
        gamer.username = "Nourhan"
        gamer.country = "Egypt"
        gamer.education_level = "high"
        gamer.gender = "female"
        gamer.date_of_birth = "1993-03-23"
        gamer.email = "nour@gmail.com"
        gamer.password = "1234567"
        gamer.save
        gamer
    }
	let (:developer) {
		developer = Developer.new
        developer.first_name = "Nourhan"
        developer.last_name = "Mohamed"
        developer.verified = "1"
        developer.gamer_id = gamer.id
        developer.save
        developer
    }
    let (:project) {
        project = Project.new
        project.name = "Project1"
        project.minAge = "19"
        project.maxAge = "50"
        project.description = "This is a project"
        project.formal = "formal"
        project.save
        project
    }
    it "should return a new project after setting owner_id and calling createcategories" do
    	result = Project.createproject({:name => "Project1", :minAge => "20", :maxAge => "40",
            :formal => "formal", :description => "da da da", :categories => "Cat1, Cat2, Cat3"}, developer.id)
        var = Project.exists?(result.id)
        expect(var).to eq(true)
    end

    it "should return a new project after creating categories and setting owner_id" do
        result = Project.createcategories(project,"Cat1, Cat2, Cat3")
        result.should be_instance_of(Project)
    end
end
