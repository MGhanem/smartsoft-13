#encoding: UTF-8
require 'spec_helper'

describe Create do
	it "is invalid without a name"
	it "is invalid without a min age"
	it "is invalid without a max age"
	it "is invalid without a min age"

	let (:gamer) {
		gamer = Gamer.new
        gamer.username = "Nourhan"
        gamer.country = "Egypt"
        gamer.education_level = "high"
        gamer.gender = "female"
        gamer.date_of_birth = "1993-03-23"
        gamer.email = "nour@gmail.com"
        gamer.password = "1234567"
        gamer.save
        gamer
}
	let (:developer) {
		developer = Developer.new
        developer.firstname = "Nourhan"
        developer.lastname = "Mohamed"
        developer.verified = "1"
        developer.gamer_id = gamer.id
        developer.save
        developer
    }

end
