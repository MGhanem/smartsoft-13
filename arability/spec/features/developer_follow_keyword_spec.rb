#encoding UTF-8
require "spec_helper"

describe "DeveloperFollowsKeyword" do
  # before :each do
  #   # @gamer

  #   @word = Keyword.new
  #   @word.name = "testkeyword"
  #   @word.save
  # end

  let(:dev) {dev = Developer.new
    dev.gamer_id = 1
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