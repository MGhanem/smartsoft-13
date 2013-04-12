#encoding UTF-8
require "spec_helper"

describe "DeveloperFollowsKeyword" do
  let(:gamer){
    gamer = Gamer.new
    gamer.username = "Mostafa"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "male"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mer92@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
  }

  let(:dev) {dev = Developer.new
    dev.gamer_id = gamer.id
    dev.first_name = "first"
    dev.last_name = "last"
    dev.verified = true
    dev.save
    dev
  }

  let(:word) {word = Keyword.new
    word.name = "testkeyword"
    word.save
    word
  }

  it "should create a relation between a developer and a Keyword" do
    dev.follow(word.id)
    followed = dev.keyword_ids.include? word.id
    expect(followed).to eq (true)
  end
  
  it "should remove the relation between a developer and a Keyword" do
    dev.unfollow(word.id)
    followed = dev.keyword_ids.include? word.id
    expect(followed).to eq (false)
  end
end