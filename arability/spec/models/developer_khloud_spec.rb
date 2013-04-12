#encoding: UTF-8
require "spec_helper"

describe "NewDeveloper" do
  let(:gamer) {
    gamer = Gamer.new
    gamer.username = "Khloud"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-08-02"
    gamer.email = "khloud.khalid7@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
    }

  it "should return false if no first name" do
    d = Developer.new
    d.last_name = "test"
    d.verified = true
    d.gamer_id = gamer.id 
    expect(d.save).to eq (false)
  end

  it "should return false if no last name" do
    d = Developer.new
    d.first_name = "test"
    d.verified = true
    d.gamer_id = gamer.id 
    expect(d.save).to eq (false)
  end

  it "should return false if no first name more than 18 characters" do
    d = Developer.new
    d.first_name = "testtesttesttesttest"
    d.last_name = "test"
    d.verified = true
    d.gamer_id = gamer.id 
    expect(d.save).to eq (false)
  end

  it "should return false if no last name more than 18 characters" do
    d = Developer.new
    d.first_name = "test"
    d.last_name = "testtesttesttesttest"
    d.verified = true
    d.gamer_id = gamer.id 
    expect(d.save).to eq (false)
  end

  it "should return false if no first name less than 3 characters" do
    d = Developer.new
    d.first_name = "t"
    d.last_name = "test"
    d.verified = true
    d.gamer_id = gamer.id 
    expect(d.save).to eq (false)
  end

  it "should return false if no last name less than 3 characters" do
    d = Developer.new
    d.first_name = "test"
    d.last_name = "t"
    d.verified = true
    d.gamer_id = gamer.id 
    expect(d.save).to eq (false)
  end

  it "should return false if no gamer_id" do
    d = Developer.new
    d.first_name = "test"
    d.last_name = "test"
    d.verified = true
    expect(d.save).to eq (false)
  end

  it "should return false if gamer_id not unique" do
    d = Developer.new
    d.first_name = "test"
    d.last_name = "test"
    d.verified = true
    d.gamer_id = gamer.id 
    d.save
    d2 = Developer.new
    d2.first_name = "test2"
    d2.last_name = "test2"
    d2.verified = true
    d2.gamer_id = gamer.id 
    expect(d2.save).to eq (false)
  end

  it "should return return true if developer information is valid" do
    d = Developer.new
    d.first_name = "test"
    d.last_name = "test"
    d.verified = true
    d.gamer_id = gamer.id 
    expect(d.save).to eq (true)
  end
end