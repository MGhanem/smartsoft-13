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
    gamer_yahya.save validate: false
    gamer_yahya
  }

  let(:prize1) {
    prize1 = Prize.new
    prize1.name = "جأجأزجأج"
    prize1.level = 1
    prize1.score = 100
    prize1.save validate: false
    prize1
  }

  let(:prize2) {
    prize2 = Prize.new
    prize2.name = "جأزةجأ"
    prize2.level = 1
    prize2.score = 100
    prize2.save validate: false
    prize2
  }

  let(:prize3) {
    prize3 = Prize.new
    prize3.name = "جأجأأزة"
    prize3.level = 1
    prize3.score = 100
    prize3.save validate: false
    prize3
  }

  let(:prize4) {
    prize4 = Prize.new
    prize4.name = "ججأأزة"
    prize4.level = 1
    prize4.score = 100
    prize4.save validate: false
    prize4
  }

  let(:prize5) {
    prize5 = Prize.new
    prize5.name = "جأجأجأ"
    prize5.level = 1
    prize5.score = 100
    prize5.save validate: false
    prize5
  }

  let(:prize6) {
    prize6 = Prize.new
    prize6.name = "جأجأأجأجأ"
    prize6.level = 3
    prize6.score = 1000
    prize6.save validate: false
    prize6
  }

  let(:prize7) {
    prize7 = Prize.new
    prize7.name = "شسيضصثف"
    prize7.level = 3
    prize7.score = 2000
    prize7.save validate: false
    prize7
  }

  before(:each) do
    gamer_adam
    gamer_yahya
    prize1
    prize2
    prize3
    prize4
    prize5
    prize6
    prize7
  end

  it "adam doesn't have any prizes" do
    gamer_adam.id.to_i.should_not eq(nil)
    gamer_adam.prizes eq([])
  end

  it "award gamer with one prize and checks if he has won it" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 1500, 3)
    gamer_adam.get_won_prizes.count.should eq(1)
  end

  it "awards gamer with one prize and remains 6 prizes available" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 1500, 3)
    gamer_adam.get_available_prizes.count.should eq(6)
  end

  it "awards gamer with 5 prizes" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 150, 1)
    gamer_adam.get_won_prizes.count.should eq(5)
  end

  it "awards gamer with 5 prizes and there are 2 available prizes left" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 150, 1)
    gamer_adam.get_available_prizes.count.should eq(2)
  end

  it "awards Adam with 5 prizes and Yahya will still have 7 prizes available" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 150, 1)
    gamer_yahya.get_available_prizes.count.should eq(7)
  end

  it "shouldn't award Adam with the same prizes again if he has already won them" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 150, 1)
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 150, 1)
    new_prizes.size.should eq(0)
  end

  it "shoudn't award the gamer with any prizes if the criteria doesn't exist" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 10000, 10000)
    gamer_adam.get_available_prizes.size.should eq(7)
  end
end
