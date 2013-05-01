#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe AdminController  do

  describe "GET #crud_categories and edit_subscription_model" do

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
      gamer.save validate: false
      gamer
    end

    it "list all gamers" do
      model1
      gamer
      sign_in(gamer)
      get "/admin/list/gamers"
      assigns(:list).should =~ [gamer]
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

    it "should add subscription model" do
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

  end

end