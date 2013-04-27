#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe AdminController  do
  describe "GET #edit_subscription_model" do
    let(:model1) do
      model = SubscriptionModel.new
      model.name = "Test"
      model.limit_search = "300"
      model.limit_follow = "200"
      model.limit_project = "100"
      model.save validate: false
      model
    end
    it "list all subscription models" do
      model1
      post :login, username: "admin", password: "admin"
      get :subscription_model
      assigns(:models).should =~ [model1]
    end
    it "should view subscription model needed to be tested" do
      model1
      post :login, username: "admin", password: "admin"
      get :edit_subscription_model, errors: nil, model_id: model1.id
      assigns(:model).should eq model1  
    end
    it "should edit subscription model" do
      model1
      put :update_subscription_model, model_id: model1.id, subscription_model: {name: "Try", limit_search: "100", limit_follow: "200", limit_project: "300"}
      assigns(:model).should_not eq model1
    end
    it "should not edit subscription model due to wrong data" do
      model1
      put :update_subscription_model, model_id: model1.id, subscription_model: {name: "", limit_search: "100", limit_follow: "200", limit_project: "300"}
      assigns(:model).should eq nil
    end    
  end
end