# encoding: utf-8

require 'spec_helper'
include 
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

  it "should get only one prize from the level" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 1500, 3)
    new_prizes.count.should eq(1)
  end

  it "should be able to get 5 new prizes" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 234, 1)
    new_prizes.count.should eq(5)
  end

  it "should give 5 prizes for gamer" do
    Prize.get_new_prizes_for_gamer(gamer_adam.id, 234,1)
    gamer_adam.prizes.length.should eq(5)
  end

  it "should not award the gamer with any prizes" do
    Prize.get_new_prizes_for_gamer(gamer_adam.id, 234, 2)
    gamer_adam.prizes.length.should eq(0)
  end

  it "should return 6" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 1500, 3)
    gamer_adam.get_available_prizes.length.should eq(6)
  end

  it "should return 5" do
    new_prizes = Prize.get_new_prizes_for_gamer(gamer_adam.id, 2500, 3)
    gamer_adam.get_available_prizes.length.should eq(5)
  end

end
