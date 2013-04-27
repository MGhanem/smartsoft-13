# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers

describe GamesController, :type => :controller do

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
    prize1
    prize2
    prize3
    prize4
    prize5
    prize6
    prize7
  end

  describe "GET show_prizes" do
    it "Adam has won all the prizes" do
       sign_in(gamer_adam)
       Prize.all.map { |prize| gamer_adam.prizes << prize }
       gamer_adam.save validate: false
       get :show_prizes
       assigns(:won_prizes).should =~ gamer_adam.get_won_prizes
    end

    it "Adam hasn't won any prize" do
      sign_in(gamer_adam)
      get :show_prizes
      assigns(:won_prizes).should =~ []
    end

    it "Adam has won all the prizes and there is no not won prizes" do
       sign_in(gamer_adam)
       Prize.all.map { |prize| gamer_adam.prizes << prize }
       gamer_adam.save validate: false
       get :show_prizes
       assigns(:not_won_prizes).should =~ gamer_adam.get_available_prizes
    end
  end

  describe "GET show_trophies" do
    it "Adam has won all the trophies" do
       sign_in(gamer_adam)
       Trophy.all.map { |trophy| gamer_adam.trophies << trophy }
       gamer_adam.save validate: false
       get :showtrophies
       assigns(:won_trophies).should =~ gamer_adam.get_won_trophies
    end

    it "Adam hasn't won any trophy" do
      sign_in(gamer_adam)
      get :showtrophies
      assigns(:won_trophies).should =~ []
    end

    it "Adam has won all the trophies and there is no not won trophies" do
       sign_in(gamer_adam)
       Trophy.all.map { |trophy| gamer_adam.trophies << trophy }
       gamer_adam.save validate: false
       get :showtrophies
       assigns(:not_won_trophies).should =~ gamer_adam.get_available_trophies
    end
  end

  describe "GET get_trophies" do
    it "should have no won trophies and no won prizes" do
      sign_in(gamer_adam)
      get :gettrophies, level: -1, score: -1
      assigns(:won_trophies).should =~ []
    end

    it "give 2 trophies to gamer" do
      sign_in(gamer_adam)
      get :gettrophies, level: 3, score: 2500
      assigns(:won_trophies).should =~ [trophy6, trophy7]
    end

    it "gamer should also be rewarded some prizes" do
      sign_in(gamer_adam)
      get :gettrophies, level: 3, score: 2500
      assigns(:bool_won_prizes).should eq(true)
    end
  end

  describe "GET score_only" do
    it "should have the score of the gamer" do
      sign_in(gamer_adam)
      get :get_score_only, score: 100000
      assigns(:score).should eq(100000)
    end
  end

  describe "GET get_prizes" do
   it "should have no won prizes" do
      sign_in(gamer_adam)
      get :get_prizes, level: -1, score: -1
      assigns(:won_prizes).should =~ []
    end

    it "give 2 prizes to gamer" do
      sign_in(gamer_adam)
      get :get_prizes, level: 3, score: 2500
      assigns(:won_prizes).should =~ [prize6, prize7]
    end
  end

end

