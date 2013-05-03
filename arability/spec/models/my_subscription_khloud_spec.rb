#encoding: UTF-8
require "spec_helper"

describe "NewMySubscription" do
  let(:gamer){
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

  let(:developer){
    developer = Developer.new
    developer.verified = true
    developer.gamer_id = gamer.id
    developer.save
    developer
  }

  let(:sm){
    sm = SubscriptionModel.new
    sm.name_en = "Free Trial"
    sm.name_ar = "موريتاني"
    sm.limit_search = 20
    sm.limit_follow = 20
    sm.limit_project = 20
    sm.limit = 20
    sm.save
    sm
  }

  it "should return false if no subscription models id", khloud: true do
    ms = MySubscription.new
    ms.developer_id = developer.id
    expect(ms.save).to eq (false)
  end

  it "should return true if all information is valid", khloud: true do
    ms = MySubscription.new
    ms.developer_id = developer.id
    ms.subscription_model_id = sm.id
    expect(ms.save).to eq (true)
  end
end