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

  let(:cat){
    cat = Category.new
    cat.english_name = "Music"
    cat.arabic_name = "مبروك"
    cat.save validate: false
    cat
  }

  let(:project){
    project = Project.new
    project.name = "Project Test"
    project.formal = true
    project.minAge = 18
    project.maxAge = 60
    project.owner_id = developer.id
    project.category = cat
    project.description = "This project has a description"
    project.save validate: false
    project
  }

  let(:s) {
      s = Synonym.new
      s.name = "شروع"
      s.approved = true
      s.save validate: false
      s
  }

  let(:keyword2){
    keyword2 = Keyword.new
    keyword2.name = "Trans"
    keyword2.synonyms = [s]
    keyword2.categories = [cat]
    keyword2.approved = "true"
    keyword2.save validate: false
    keyword2
  }

#Salma's tests
  before (:each) do
    developer
    cat
    project
    keyword2
    s
  end

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

  it "should filter relevant keywords for a project" do
    result = Project.filter_keywords(project.id,cat.id)
    result.should include(keyword2)
  end

end
