#encoding: UTF-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe GamesController, :type => :controller do
	let(:test_gamer) {
	    gamer = Gamer.new
	    test_gamer.username = "kareem"
	    test_gamer.country = "Egypt"
	    test_gamer.education_level = "University"
	    test_gamer.gender = "male"
	    test_gamer.date_of_birth = "1992-04-18"
	    test_gamer.email = "kareem@gmail.com"
	    test_gamer.password = "password"
	    test_gamer.password_confirmation = "password"
	    test_gamer.confirmed_at  = Time.now
	    test_gamer.save validate: false
	    test_gamer
	}

	it "should"
end