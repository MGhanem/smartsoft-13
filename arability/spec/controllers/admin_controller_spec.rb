#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe AdminController  do

  describe "GET #admin_options" do

    let(:cat1) do
      category = Category.new
      category.english_name = "Test"
      category.arabic_name = "تجربة"
      category.save validate: false
      category
    end

    let(:model1) do
      model = SubscriptionModel.new
      model.name_ar = "تجربة"
      model.name_en = "Test"
      model.limit_search = "300"
      model.limit_follow = "200"
      model.limit_project = "100"
      model.save validate: false
      model
    end

    let(:gamer) do
      gamer = Gamer.new
      gamer.username = "Omar"
      gamer.country = "Egypt"
      gamer.gender = "male"
      gamer.date_of_birth = "1993-10-23"
      gamer.email = "omar@gmail.com"
      gamer.password = "1234567"
      gamer.education_level = "University"
      gamer.admin = true
      gamer.confirmed_at = Time.now
      gamer.save validate: false
      gamer
    end

    let(:gamer2) do
      gamer = Gamer.new
      gamer.username = "ahmed"
      gamer.country = "Egypt"
      gamer.gender = "male"
      gamer.date_of_birth = "1993-10-23"
      gamer.email = "ahmed@gmail.com"
      gamer.password = "1234567"
      gamer.education_level = "University"
      gamer.confirmed_at = Time.now
      gamer.save validate: false
      gamer
    end

    let(:developer) do
      gamer
      developer = Developer.new
      developer.gamer_id = gamer.id
      developer.save
      developer
    end

    let(:project) do
      gamer
      developer
      project = Project.new
      project.name = "first project"
      project.minAge = 50
      project.maxAge = 60
      project.owner_id = developer.id
      project.save
      project
    end

    let(:word) do
      word = Keyword.new
      word.name = "Test"
      word.is_english = true
      word.save validate: false
      word
    end

    it "should list all gamers" do
      gamer
      sign_in(gamer)
      get :list_gamers
      assigns(:list).should =~ [gamer]
    end

    it "should list all developers" do
      gamer
      developer
      sign_in(gamer)
      get :list_developers
      assigns(:list).should =~ [developer]
    end

    it "should make ahmed an admin" do 
      gamer
      gamer2
      sign_in(gamer)
      post :make_admin, email: gamer2.email
      Gamer.find_by_email(gamer2.email).admin.should eq(true)
    end

    it "should not make an admin" do
      gamer2
      sign_in(gamer)
      post :make_admin, email: "karimkkk@gamil.com"
      response.should redirect_to("http://test.host/admin/make_admin")
    end

    it "should remove the current existing admin" do
      gamer
      gamer2
      sign_in(gamer)
      post :make_admin, email: gamer2.email
      Gamer.find_by_email(gamer2.email).admin.should eq(true)
      get :remove_admin, id: gamer2.id
      Gamer.find_by_id(gamer2.id).admin.should eq(false)
    end

    it "should not remove the not existing admin" do
      gamer
      gamer2
      sign_in(gamer)
      get :remove_admin, id: gamer2.id
      Gamer.find_by_id(gamer2.id).admin.should eq(false)
      response.should redirect_to("http://test.host/admin/list/admins")
    end

    it "should not remove yourself from admins" do
      gamer
      sign_in(gamer)
      get :remove_admin, id: gamer.id
      Gamer.find_by_id(gamer.id).admin.should eq(true)
      response.should redirect_to("http://test.host/admin/list/admins")
    end

    it "should list all projects" do
      project
      gamer
      sign_in(gamer)
      get :list_projects
      assigns(:list).should =~ [project]
    end

    it "should list all developer's projects" do
      gamer
      developer
      project
      sign_in(gamer)
      get :list_developer_projects, id: developer.id
      assigns(:list).should =~ [project]
    end

    it "list all subscription models" do
      model1
      gamer
      sign_in(gamer)
      get :view_subscription_models
      assigns(:models).should =~ [model1]
    end

    it "should view subscription model needed to be tested" do
      model1
      gamer
      sign_in(gamer)
      get :edit_subscription_model, errors: nil, model_id: model1.id
      assigns(:model).should eq model1  
    end

    it "should edit subscription model" do
      model1
      put :update_subscription_model, model_id: model1.id, subscription_model: {name_en: "Try", name_ar: "محاولة", limit_search: "100", limit_follow: "200", limit_project: "300"}
      assigns(:model).should_not eq model1
    end

    it "should add category" do
      gamer
      sign_in(gamer)
      post :add_category, english_name: "trial", arabic_name: "تجربة"
      assigns(:success).should eq (true)  
    end

    it "list all categories" do
      cat1
      gamer
      sign_in(gamer)
      get :view_categories
      assigns(:categories).should =~ [cat1]
    end

    it "delete category" do
      cat1
      gamer
      sign_in(gamer)
      expect{
      get :delete_category, category_id: cat1.id
      }.to change(Category,:count).by(-1)
    end   

    it "should not edit subscription model due to wrong data" do
      model1
      put :update_subscription_model, model_id: model1.id, subscription_model: {name_en: "", name_ar: "", limit_search: "100", limit_follow: "200", limit_project: "300"}
      assigns(:model).should eq nil
    end

    it "list all reports" do
      word
      gamer
      sign_in(gamer)
      success , report = Report.create_report(gamer, word)
      get :view_reports
      assigns(:reports).should =~ [report]
    end

    it "remove report but keep word approved" do
      word
      gamer
      sign_in(gamer)
      success , reported = Report.create_report(gamer, word)
      get :ignore_report, report_id: reported.id
      assigns(:reportAll).should eq []
    end

    it "remove report and unapprove word" do
      word
      gamer
      sign_in(gamer)
      success , reported = Report.create_report(gamer, word)
      get :unapprove_word, report_id: reported.id
      result = Keyword.find_by_id(word.id).approved
      expect(result).to eq (false)
      assigns(:reportAll).should eq []
    end

  end

end