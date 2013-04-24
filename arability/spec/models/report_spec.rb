#encoding: UTF-8
require 'spec_helper'
describe Report do
  let(:gamer) {
    g = Gamer.new
    g.username = "Gamer"
    g.country = "Egypt"
    g.education_level = "Graduate"
    g.date_of_birth = "Sun, 09 Apr 1995"
    g.gender = "male"
    g.email = "gamer@example.com"
    g.password = "1234567"
    g.save validate: false
    g
  }

  let(:keyword) {
    k = Keyword.new
    k.name ="trial"
    k.approved = "true"
    k.save
    k
  }

  let(:synonym){
    s = Synonym.new
    s.name =  "الثاني"
    s.keyword_id =  keyword.id
    s.approved = "true"
    s.save
    s
  }

  it "should save a report from a gamer to a keyword" do
    success, report = Report.create_report(gamer, keyword)
    report.reported_word_type.should eq("Keyword")
    success.should eq(true)
  end

  it "should save a report from a gamer to a synonym" do
    success, report = Report.create_report(gamer, synonym)
    report.reported_word_type.should eq("Synonym")
    success.should eq(true)
  end

  it "should not save a report from a gamer without a reported word" do
    r = Report.new
    r.gamer = gamer
    r.save.should eq(false)
  end

  it "should not save a report without a gamer" do
    r = Report.new
    r.reported_word = keyword
    r.save.should eq(false)
  end

  it "should not save duplicate records" do
    success, report = Report.create_report(gamer, keyword)
    success.should eq(true)
    success, report = Report.create_report(gamer, keyword)
    success.should eq(false)
    report.errors.messages.should eq({:gamer_id=>["You reported this word before"]})
  end
end