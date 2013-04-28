#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe AdminController  do

  describe "GET #crud_categories" do
    let(:cat1) do
      category = Category.new
      category.english_name = "Test"
      category.arabic_name = "تجربة"
      category.save validate: false
      category
    end

	  it "should login the user if correct username and password" do
		  get :login
		  expect(response.code).to eq("200")
	  end

	  it "should redirect to login page" do
		  get :index
		  response.should redirect_to :action => :login
	  end

	  it "renders the login template" do
      get :login
      expect(response).to render_template("login")
    end

    it "should add subscription model" do
      post :login, username: "admin", password: "admin"
      post :add_category, english_name: "trial", arabic_name: "تجربة"
      assigns(:success).should eq (true)  
    end

    it "list all categories" do
      cat1
      post :login, username: "admin", password: "admin"
      get :view_categories
      assigns(:categories).should =~ [cat1]
    end

    it "delete category" do
      cat1
      post :login, username: "admin", password: "admin"
      expect{
      get :delete_category, category_id: cat1.id
      }.to change(Category,:count).by(-1)
    end   

  end

end