# encoding: UTF-8
require 'spec_helper'

describe UserMailer do
  it "sends generic email" do
    mail = UserMailer.generic_email("to","subject","message")
    mail.to.should eq(["to"])
    mail.subject.should eq("subject")
    mail.body.should eq("message")
  end

  let(:gamer) {
    gamer = Gamer.new(email: "test@test.com")
    gamer.save validate: false
    gamer
  }
  let(:developer) {Developer.create!(first_name: "firstname",
        last_name: "lastname", gamer_id: gamer.id)
  }

  it "sends follow notification" do
    success, keyword = Keyword.add_keyword_to_database("test")
    synonym = Synonym.create(:name => "تبت")
    mail = UserMailer.follow_notification(developer, keyword,"message")
    mail.to.should eq([gamer.email])
    mail.subject.should match(keyword.name)
    #mail.body.should match(developer.first_name)
    #mail.body.should match(keyword.name)
    #mail.body.should match(synonym.name)
  end

  it "sends invitation" do
    mail = UserMailer.invite("test@test.com", developer)
    mail.to.should eq(["test@test.com"])
    mail.subject.should match("invite")
    #mail.body.should match(developer.first_name)
  end
end
