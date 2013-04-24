#encoding: utf-8
require "spec_helper"
require "string_helper"
include StringHelper

describe StringHelper do

  it "Should recognise english strings with spaces" do
    is_english_string("test testing").should eq(true)
  end

  it "Should not recognise arabic strings with spaces" do
    is_english_string("سبت").should eq(false)
  end

  it "Should not recognise mixed strings with spaces" do
    is_english_string("سبت akdjf").should eq(false)
  end

end
