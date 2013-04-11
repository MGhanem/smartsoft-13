#encoding: UTF-8
require "spec_helper"

describe Prize do

	it "should return false since name and image is empty" do
		success, prize = Prize.add_prize_to_database(nil, 1, 1, nil)
		expect(success).to eq(false)
	end

	it "should return false since name and score and level and image is empty" do
		success, prize = Prize.add_prize_to_database(nil, nil, nil, nil)
		expect(success).to eq(false)
	end

end