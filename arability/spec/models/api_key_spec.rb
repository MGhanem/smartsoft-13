# encoding: utf-8
require 'spec_helper'

describe ApiKey, mohamed: true do
  let (:key) { ApiKey.create(developer_id: 1, website: "test.com") }
  let (:word) { Keyword.add_keyword_to_database("test", true, true)[1] }
  let (:translation) { Synonym.record_synonym("ستب", word.id, true)[1] }

  it "should generate an api key on save" do
    key = ApiKey.create(developer_id: 1, website: "test.com")
    key.token.should_not eq(nil)
  end

  it "should get synonym" do
    translation
    key.get_synonym_for("test").should eq(translation)
  end

  it "should get synonym according to project criteria" do
    key.project = Project.create!(name: "a", minAge: 10, maxAge: 20)
    key.save
    translation
    key.get_synonym_for("test").should eq(translation)
  end
end
