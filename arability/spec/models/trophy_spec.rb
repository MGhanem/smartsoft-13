#encoding: UTF-8
require "spec_helper"

describe Trophy do

	it "should not be saved" do
		trophy = Trophy.new
		expect(trophy.save).to eq(false)
	end

	it "should return false since name and image is empty" do
		success, trophy = Trophy.add_prize_to_database(nil, 1, 1, nil)
		expect(success).to eq(false)
	end

	it "should return false since name and score and level and image is empty" do
		success, trophy = Trophy.add_prize_to_database(nil, nil, nil, nil)
		expect(success).to eq(false)
	end

end