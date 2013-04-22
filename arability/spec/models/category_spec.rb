#encoding:utf-8
require 'spec_helper'

describe Category do
  it "should create new category only if not exists" do
    success, category1 =
      Category.add_category_to_database_if_not_exists("test", "بتتش")
    success.should eq(true)
    success, category2 =
      Category.add_category_to_database_if_not_exists("test ", "بتتش")
    success.should eq(true)
    category2.name.should eq("test")
    category1.id.should eq(category2.id)
  end

  it "should create new two word category in english and arabic" do
    success, category =
      Category.add_category_to_database_if_not_exists("test test ", " بتتش بتتش ")
    success.should eq(true)
    category.english_name.should eq("test test")
    category.arabic_name.should eq("بتتش بتتش")
  end

  it "Should not create category if arabic name already exists but not english" do
    success, category =
      Category.add_category_to_database_if_not_exists("test", "بتتش")
    success.should eq(true)
    category.arabic_name.should eq("بتتش")
    success, category =
      Category.add_category_to_database_if_not_exists("testing", "بتتش")
    success.should eq(false)
  end

  it "Should not create category if english name already exists but not arabic" do
    success, category =
      Category.add_category_to_database_if_not_exists("test", "بتتش")
    success.should eq(true)
    category.arabic_name.should eq("بتتش")
    success, category =
      Category.add_category_to_database_if_not_exists("test", "بتتش بتتش")
    success.should eq(false)
  end

	it "should create a category after downcasing and stripping" do
    success, category =
      Category.add_category_to_database_if_not_exists("Test ", " بتتش بتتش ")
    success.should eq(true)
    category.english_name.should eq("test")
    category.arabic_name.should eq("بتتش بتتش")
  end

	it "should not create a category if it contains anything other than letters" do
    success, category =
      Category.add_category_to_database_if_not_exists("Test 2", "بتتش 2")
    success.should eq(false)
  end

	it "should not create a category if it contains both english and arabic in one of the names" do
    success, category =
      Category.add_category_to_database_if_not_exists("بتتش test", "بتتش test")
    success.should eq(false)
  end
end
