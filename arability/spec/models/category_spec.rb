#encoding:utf-8
require 'spec_helper'

describe Category do
  it "should create new category only if not exists" do
    success, category1 =
      Category.add_category_to_database_if_not_exists("test")
    success.should eq(true)
    success, category2 =
      Category.add_category_to_database_if_not_exists("test ")
    success.should eq(true)
    category2.name.should eq("test")
    category1.id.should eq(category2.id)
  end

  it "should create new two word category in english and arabic" do
    success, category =
      Category.add_category_to_database_if_not_exists("test test ")
    success.should eq(true)
    category.name.should eq("test test")

    success, category =
      Category.add_category_to_database_if_not_exists("test test")
    success.should eq(true)
    category.name.should eq("test test")

    success, category =
      Category.add_category_to_database_if_not_exists(" بتتش بتتش ")
    success.should eq(true)
    category.name.should eq("بتتش بتتش")

    success, category =
      Category.add_category_to_database_if_not_exists("بتتش بتتش")
    success.should eq(true)
    category.name.should eq("بتتش بتتش")
  end

  it "should create new category in arabic" do
    success, category =
      Category.add_category_to_database_if_not_exists("بتتش")
    success.should eq(true)
    category.name.should eq("بتتش")
  end

	it "should create a category after downcasing and stripping" do
    success, category =
      Category.add_category_to_database_if_not_exists("Test ")
    success.should eq(true)
    category.name.should eq("test")
  end

	it "should not create a category if it contains anything other than letters" do
    success, category =
      Category.add_category_to_database_if_not_exists("Test 2")
    success.should eq(false)

    success, category =
      Category.add_category_to_database_if_not_exists("بتتش 2")
    success.should eq(false)
  end

	it "should not create a category if it contains both english and arabic" do
    success, category =
      Category.add_category_to_database_if_not_exists("بتتش test")
    success.should eq(false)
  end
end
