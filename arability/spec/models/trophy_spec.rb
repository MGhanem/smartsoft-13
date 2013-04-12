#encoding: UTF-8
require "spec_helper"

describe Trophy do

	it "should not be saved" do
		trophy = Trophy.new
		expect(trophy.save).to eq(false)
	end

	it "should return false since name and image is empty" do
		success, trophy = Trophy.add_trophy_to_database(nil, 1, 1, nil)
		expect(success).to eq(false)
	end

	it "should return false since name and score and level and image is empty" do
		success, trophy = Trophy.add_trophy_to_database(nil, nil, nil, nil)
		expect(success).to eq(false)
	end

	it "should create a trophy" do
		photo = File.new(Rails.root + 'spec/assets/attachments/Koala.jpg')
		success, trophy = Trophy.add_trophy_to_database("التروفى", 5, 5, photo)
		expect(success).to eq(true)
	end

	it "should delete a trophy" do 
		photo = File.new(Rails.root + 'spec/assets/attachments/Koala.jpg')
		success, trophy = Trophy.add_trophy_to_database("التروفى", 5, 5, photo)
		expect(success).to eq(true)
		id = Trophy.where(:name => "التروفى").first.id
		Trophy.where(:name => "التروفى").first.delete
		troph = Trophy.find_by_id(id)
		expect(troph.present?).to eq(false)
	end

end