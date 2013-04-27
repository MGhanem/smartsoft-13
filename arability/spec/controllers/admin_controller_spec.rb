#encoding: UTF-8
require "spec_helper"

describe AdminController  do
	
	let(:model1){
	  model = SubscriptionModel.new
    model.name = "Test"
    model.limit_search = "300"
    model.limit_follow = "200"
    model.limit_project = "100"
    model.save
    model
  }

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

    it "list all subscription models" do
      get :subscription_model
      puts response.inspect
      response.code.should eq("302")
    end

    # it "list all subscription modelss" do
    #   get :edit_subscription_model, model_id: model1.id
    #   response.code.should eq("302")
    # end
    
end