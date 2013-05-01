# encoding:utf-8
require 'spec_helper'

describe Project do

  let(:developer){
    developer=Developer.new
    developer.verified = true
    developer.gamer_id= 1
    developer.save
    developer
  }

  let(:project){
  project = Project.new
  project.name = "Project Test"
  project.formal = true
  project.minAge = 18
  project.maxAge = 60
  project.owner_id = developer.id
  project.category_id = cat.id
  project.description = "This project has a description"
  project.save
  project

}

let(:cat){
  cat = Category.new
  cat.id = "13"
  cat.english_name = "Music"
  cat.arabic_name = "مبروك"
  cat.save
  cat
}

let(:keyword1){
  keyword1 = Keyword.new
  keyword1.id = 1
  keyword1.name = "Art"
  keyword1.synonyms = [Synonym.create(name: "hey", keyword_id: keyword1.id, approved: true)]
  keyword1.categories = [Category.find(cat.id)]
  keyword1.approved = "true"
  keyword1.save
  keyword1
}

#Salma's tests

  it "Should have a name" do
  project.name = nil
  s = project.save
  s.should eq(false)
end

it "Name mustn't be of length > 30" do
  project.name = "abcdefgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg"
  s = project.save
  s.should eq(false)
end

it "Should have a name of max length of 30" do
  project.name = "Project1"
  s = project.save
  s.should eq(true)
end

it "Minimum age should be numerical" do
  project.minAge = "abc"
  s = project.save
  s.should eq(false)
end

it "Maximum age should be less than 100" do
  project.maxAge = "101"
  s = project.save
  s.should eq(false)
end

it "Minimum age should be greater than 9" do
  project.minAge = "8"
  s = project.save
  s.should eq(false)
end

it "should return a new project after calling createcategories" do
  result = Project.createproject({ name: "Project1", minAge: "20", maxAge: "40",
    formal: "formal", description: "da da da", category: cat.id }, developer.id)
  var = Project.exists?(result.id)
  expect(var).to eq(true)
end

it "should return a new project after finding its category" do
  result = Project.createcategories(project,cat.id)
  var = Project.exists?(result.id)
  expect(var).to eq(true)
  expect(project.category).to be_instance_of(Category)
end

end
