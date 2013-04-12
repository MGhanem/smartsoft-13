#encoding: UTF-8
require "spec_helper"

describe AdminController  do
	
	it "should login the user if correct username and password" do
		get :login
		expect(response.code).to eq("200")
	end

	it "should redirect to login page" do
		get :index
		response.should redirect_to("/admin/login")
	end

	it "renders the login template" do
      get :login
      expect(response).to render_template("login")
    end

    it "should login as admin" do
    	post "/admin/login", :username => "admin", :password => "admin"
    	expect(response.code).to eq("200")
    	expect(response).to render_template("index")
    end

end