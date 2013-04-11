#encoding: UTF-8
require "spec_helper"

describe AdminController  do
	
	it "should login the user if correct username and password" do
		get :login
		expect(response.code).to eq("200")
	end

	it "should redirect to login page" do
		get :index
		response.should redirect_to("/en/admin/login")
	end

end