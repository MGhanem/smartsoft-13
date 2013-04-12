#encoding: UTF-8
require "spec_helper"

describe Prize do

	it "should not be saved" do
		prize = Prize.new
		expect(prize.save).to eq(false)
	end

	it "should return false since name and image is empty" do
		success, prize = Prize.add_prize_to_database(nil, 1, 1, nil)
		expect(success).to eq(false)
	end

	it "should return false since name and score and level and image is empty" do
		success, prize = Prize.add_prize_to_database(nil, nil, nil, nil)
		expect(success).to eq(false)
	end

	it "should create a prize" do
		photo = File.new(Rails.root + 'spec/assets/attachments/Koala.jpg')
		success, prize = Prize.add_prize_to_database("التروفى", 5, 5, photo)
		expect(success).to eq(true)
	end

	it "should delete a prize" do 
		photo = File.new(Rails.root + 'spec/assets/attachments/Koala.jpg')
		success, prize = Prize.add_prize_to_database("التروفى", 5, 5, photo)
		expect(success).to eq(true)
		id = Prize.where(:name => "التروفى").first.id
		Prize.where(:name => "التروفى").first.delete
		priz = Prize.find_by_id(id)
		expect(priz.present?).to eq(false)
	end

end