#encoding UTF-8
require "spec_helper"

describe "DeveloperFollowsKeyword" do
  before :each do
    @gamer = Gamer.create :userid => "myuserid", :password => "mypasswd", :user_first_name => "test"
    @dev = Developer.create :gamer_id => @gamer.id, :first_name => "first", :last_name => "last", :verified => true
  end
  it "should create a relation between a developer and a Keyword" do
    gamer = Gamer.new


    dev = Developer.new
    dev.gamer_id = gamer.id
    dev.first_name = "first"
    dev.last_name = "last"
    dev.verified = true

    word = Keyword.new
    word.name = "testkeyword"
    word.save



  end

  
end