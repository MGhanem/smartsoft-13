#encoding: utf-8
require 'spec_helper'

describe "gamer admin" do
	let(:test_gamer){
		test_gamer = Gamer.new
        test_gamer.username = "kareem"
        test_gamer.country = "Egypt"
        test_gamer.education_level = "high"
        test_gamer.gender = "male"
        test_gamer.date_of_birth = "1993-03-23"
        test_gamer.email = "kareem@gmail.com"
        test_gamer.password = "kareem"
        test_gamer.save
        test_gamer
	}

	it "should make the gamer admin" do
		test_gamer
		test_gamer.make_admin
		test_gamer.admin.should eq(true)
	end

	it "should make the gamer not an admin" do
		test_gamer
		test_gamer.make_admin
		test_gamer.admin.should eq(true)
		test_gamer.remove_admin
		test_gamer.admin.should eq(false)
	end

end