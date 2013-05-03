# encoding: utf-8
require 'spec_helper'
describe "Get Prizes" do
  
  let(:gamer_adam) {
    gamer_adam = Gamer.new
    gamer_adam.username = "adamggg"
    gamer_adam.country = "Egypt"
    gamer_adam.education_level = "University"
    gamer_adam.gender = "male"
    gamer_adam.date_of_birth = "1992-04-18"
    gamer_adam.email = "ag@gmail.com"
    gamer_adam.password = "password"
    gamer_adam.password_confirmation = "password"
    gamer_adam.confirmed_at = Time.now
    gamer_adam.save validate: false
    gamer_adam
  }

  let(:gamer_yahya) {
    gamer_yahya = Gamer.new
    gamer_yahya.username = "yaham"
    gamer_yahya.country = "Egypt"
    gamer_yahya.education_level = "University"
    gamer_yahya.gender = "male"
    gamer_yahya.country = "Egypt"
    gamer_yahya.date_of_birth = "1993-02-18"
    gamer_yahya.password = "password"
    gamer_yahya.password_confirmation = "password"
    gamer_yahya.email = "ym@gmail.com"
    gamer_yahya.confirmed_at = Time.now
    gamer_yahya.save validate: false
    gamer_yahya
  }

  let(:trophy1) {
    trophy1 = Trophy.new
    trophy1.name = "جأجأزجأج"
    trophy1.level = 1
    trophy1.score = 100
    trophy1.save validate: false
    trophy1
  }

  let(:trophy2) {
    trophy2 = Trophy.new
    trophy2.name = "جأزةجأ"
    trophy2.level = 1
    trophy2.score = 100
    trophy2.save validate: false
    trophy2
  }

  let(:trophy3) {
    trophy3 = Trophy.new
    trophy3.name = "جأجأأزة"
    trophy3.level = 1
    trophy3.score = 100
    trophy3.save validate: false
    trophy3
  }

  let(:trophy4) {
    trophy4 = Trophy.new
    trophy4.name = "ججأأزة"
    trophy4.level = 1
    trophy4.score = 100
    trophy4.save validate: false
    trophy4
  }

  let(:trophy5) {
    trophy5 = Trophy.new
    trophy5.name = "جأجأجأ"
    trophy5.level = 1
    trophy5.score = 100
    trophy5.save validate: false
    trophy5
  }

  let(:trophy6) {
    trophy6 = Trophy.new
    trophy6.name = "جأجأأجأجأ"
    trophy6.level = 3
    trophy6.score = 1000
    trophy6.save validate: false
    trophy6
  }

  let(:trophy7) {
    trophy7 = Trophy.new
    trophy7.name = "شسيضصثف"
    trophy7.level = 3
    trophy7.score = 2000
    trophy7.save validate: false
    trophy7
  }

  before(:each) do
    gamer_adam
    gamer_yahya
    trophy1
    trophy2
    trophy3
    trophy4
    trophy5
    trophy6
    trophy7
  end

  it "adam doesn't have any trophies" do
    gamer_adam.id.to_i.should_not eq(nil)
    gamer_adam.trophies eq([])
  end

  it "award gamer with one trophy and checks if he has won it" do
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 1500, 3)
    gamer_adam.get_won_trophies.count.should eq(1)
  end

  it "awards gamer with one trophy and remains 6 trophies available" do
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 1500, 3)
    gamer_adam.get_available_trophies.count.should eq(6)
  end

  it "awards gamer with 5 trophies" do
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 150, 1)
    gamer_adam.get_won_trophies.count.should eq(5)
  end

  it "awards gamer with 5 trophies and there are 2 available trophies left" do
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 150, 1)
    gamer_adam.get_available_trophies.count.should eq(2)
  end

  it "awards Adam with 5 trophies and Yahya will still have 7 trophies available" do
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 150, 1)
    gamer_yahya.get_available_trophies.count.should eq(7)
  end

  it "shouldn't award Adam with the same trophies again if he has already won them" do
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 150, 1)
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 150, 1)
    new_trophies.size.should eq(0)
  end

  it "shoudn't award the gamer with any prizes if the criteria doesn't exist" do
    new_trophies = Trophy.get_new_trophies_for_gamer(gamer_adam.id, 10000, 10000)
    gamer_adam.get_available_trophies.size.should eq(7)
  end
end
