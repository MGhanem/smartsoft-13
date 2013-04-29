# encoding: UTF-8
require 'spec_helper'

describe UserMailer, mohamed: true do
  it "sends generic email" do
    mail = UserMailer.generic_email("to", "subject", "message")
    mail.to.should eq(["to"])
    mail.subject.should eq("subject")
    mail.body.should eq("message")
  end

  let(:gamer) {
    gamer = Gamer.new(email: "test@test.com", username: "test")
    gamer.save validate: false
    gamer
  }
  let(:developer) {
    Developer.create!(gamer_id: gamer.id)
  }

  it "sends follow notification" do
    success, keyword = Keyword.add_keyword_to_database("test")
    synonym = Synonym.create(name: "تبت")
    mail = UserMailer.follow_notification(developer, keyword, synonym)
    mail.to.should eq([gamer.email])
    mail.subject.should match(keyword.name)
    mail.body.should match(keyword.name)
    mail.body.should match(synonym.name)
  end

  it "sends invitation" do
    mail = UserMailer.invite("test@test.com", developer)
    mail.to.should eq(["test@test.com"])
    mail.subject.should match("invite")
    # This view has not yet been implemented. once it has I will remove the comment
    # mail.body.should match(developer.first_name)
  end
end
