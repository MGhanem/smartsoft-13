#encoding:utf-8
require 'spec_helper'

describe Category do
  it "should create new category only if not exists" do
    success, category1 = Category.add_category_to_database_if_not_exists("test")
    success.should eq(true)
    success, category2 = Category.add_category_to_database_if_not_exists("test ")
    success.should eq(true)
    category2.name.should eq("test")
    category1.id.should eq(category2.id)
  end
  it "should create new category in english or arabic" do
    success, category1 = Category.add_category_to_database_if_not_exists("بتتش")
    success.should eq(true)
    success, category2 = Category.add_category_to_database_if_not_exists(" بتتش")
    success.should eq(true)
    category2.name.should eq("بتتش")
    category1.id.should eq(category2.id)
  end
end
