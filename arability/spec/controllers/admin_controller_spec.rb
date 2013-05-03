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
      model.limit = "1000"
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

    let(:synonym) do
      synonym = Synonym.new
      synonym.name = "منمن"
      synonym.keyword_id = word.id
      synonym.save
      synonym
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

    it "should list all developer's projects" do
      gamer
      developer
      project
      sign_in(gamer)
      get :list_developer_projects, id: developer.id
      assigns(:list).should =~ [project]
    end

    it "list all subscription models", omar: true do
      model1
      gamer
      sign_in(gamer)
      get :view_subscription_models
      assigns(:models).should =~ [model1]
    end

    it "should view subscription model needed to be tested", omar: true do
      model1
      gamer
      sign_in(gamer)
      get :edit_subscription_model, errors: nil, model_id: model1.id
      assigns(:model).should eq model1  
    end

    it "should edit subscription model", omar: true do
      model1
      gamer
      sign_in(gamer)
      put :update_subscription_model, model_id: model1.id, subscription_model: {name_en: "Try", name_ar: "محاولة", limit_search: "100", limit_follow: "200", limit_project: "300", limit: "400"}
      expect(SubscriptionModel.find_by_id(model1.id).name_en).to_not eq model1.name_en
      response.should redirect_to("http://test.host/admin/view_subscription_models?locale=ar")
    end

    it "should edit category", omar: true do
      cat1
      gamer
      sign_in(gamer)
      put :update_category, category_id: cat1.id, category: {english_name: "Try", arabic_name: "محاولة"}
      expect(Category.find_by_id(cat1.id).english_name).to_not eq cat1.english_name
      response.should redirect_to("http://test.host/admin/view_categories?locale=ar")
    end

    it "should add category", omar: true do
      gamer
      sign_in(gamer)
      post :add_category, english_name: "trial", arabic_name: "تجربة"
      assigns(:success).should eq (true)
      response.should redirect_to("http://test.host/admin/view_categories")
    end

    it "should not add category for incorrect data", omar: true do
      gamer
      sign_in(gamer)
      post :add_category, english_name: "نمنم", arabic_name: "nmnm"
      assigns(:success).should eq (false)
    end

    it "list all categories", omar: true do
      cat1
      gamer
      sign_in(gamer)
      get :view_categories
      assigns(:categories).should =~ [cat1]
    end

    it "delete category", omar: true do
      cat1
      gamer
      sign_in(gamer)
      expect{
      get :delete_category, category_id: cat1.id
      }.to change(Category,:count).by(-1)
      response.should redirect_to("http://test.host/admin/view_categories?locale=ar")
    end   

    it "delete subscription model", omar: true do
      model1
      gamer
      sign_in(gamer)
      expect{
      get :delete_subscription_model, model_id: model1.id
      }.to change(SubscriptionModel,:count).by(-1)
      response.should redirect_to("http://test.host/admin/view_subscription_models?locale=ar")
    end   

    it "should not edit subscription model due to wrong data", omar: true do
      model1
      gamer
      sign_in(gamer)
      put :update_subscription_model, model_id: model1.id, subscription_model: {name_en: "", name_ar: "", limit_search: "100", limit_follow: "200", limit_project: "300", limit: "flfl"}
      expect(SubscriptionModel.find_by_id(model1.id).name_en).to eq model1.name_en
      response.should redirect_to("http://test.host/admin/1/edit_subscription_model?errors%5Blimit%5D%5B%5D=%D9%8A%D8%AC%D8%A8+%D8%A3%D9%86+%D9%8A%D9%83%D9%88%D9%86+%D8%A7%D9%84%D8%AD%D8%AF+%D8%A7%D9%84%D8%A7%D9%82%D8%B5%D9%89+%D8%B1%D9%82%D9%85&errors%5Bname_ar%5D%5B%5D=%D9%84%D8%A7+%D9%8A%D9%85%D9%83%D9%86+%D8%A3%D9%86+%D9%8A%D9%83%D9%88%D9%86+%D8%A7%D9%84%D8%A5%D8%B3%D9%85+%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A+%D9%81%D8%A7%D8%B1%D8%BA&errors%5Bname_ar%5D%5B%5D=%D9%87%D8%B0%D8%A7+%D8%A7%D9%84%D8%A5%D8%B3%D9%85+%D9%84%D9%8A%D8%B3+%D8%A8%D8%A7%D9%84%D9%84%D8%BA%D8%A9+%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9&errors%5Bname_en%5D%5B%5D=%D9%84%D8%A7+%D9%8A%D9%85%D9%83%D9%86+%D8%A3%D9%86+%D9%8A%D9%83%D9%88%D9%86+%D8%A7%D9%84%D8%A5%D8%B3%D9%85+%D8%A7%D9%84%D8%A5%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A+%D9%81%D8%A7%D8%B1%D8%BA&errors%5Bname_en%5D%5B%5D=%D9%87%D8%B0%D8%A7+%D8%A7%D9%84%D8%A5%D8%B3%D9%85+%D9%84%D9%8A%D8%B3+%D8%A8%D8%A7%D9%84%D9%84%D8%BA%D8%A9+%D8%A7%D9%84%D8%A5%D9%86%D8%AC%D9%84%D9%8A%D8%B2%D9%8A%D8%A9&locale=ar")
    end

    it "should not edit category due to wrong data", omar: true do
      cat1
      gamer
      sign_in(gamer)
      put :update_category, category_id: cat1.id, category: {english_name: "", arabic_name: ""}
      expect(Category.find_by_id(cat1.id).english_name).to eq cat1.english_name
      response.code.should eq("302")
    end

    it "list all reports", omar: true do
      word
      gamer
      sign_in(gamer)
      success , report = Report.create_report(gamer, word)
      get :view_reports
      assigns(:reports).should =~ [report]
    end

    it "remove report but keep word approved", omar: true do
      word
      gamer
      sign_in(gamer)
      success , reported = Report.create_report(gamer, word)
      get :ignore_report, report_id: reported.id
      assigns(:reportAll).should eq []
    end

    it "remove report and unapprove keyword", omar: true do
      word
      gamer
      sign_in(gamer)
      success , reported = Report.create_report(gamer, word)
      get :unapprove_word, report_id: reported.id
      result = Keyword.find_by_id(word.id).approved
      expect(result).to eq (false)
      assigns(:reportAll).should eq []
    end

    it "remove report and unapprove synonym", omar: true do
      synonym
      gamer
      sign_in(gamer)
      success , reported = Report.create_report(gamer, synonym)
      get :unapprove_word, report_id: reported.id
      result = Synonym.find_by_id(synonym.id).approved
      expect(result).to eq (false)
      assigns(:reportAll).should eq []
    end

  end

end