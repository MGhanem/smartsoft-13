#encoding: UTF-8
require "spec_helper"

describe Trophy do

	it "should return false since name and image is empty" do
		success, trophy = Trophy.add_trophy_to_database("", 1, 1, nil)
		expect(success).to eq(false)
	end

end