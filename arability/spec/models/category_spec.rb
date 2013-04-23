#encoding:utf-8
require 'spec_helper'

describe Category do
  describe "Add category to database" do
    it "should create new category only if not exists", mohamed: true do
      success, category1 =
        Category.add_category_to_database_if_not_exists("test", "بتتش")
      success.should eq(true)
      success, category2 =
        Category.add_category_to_database_if_not_exists("test ", "بتتش")
      success.should eq(true)
      category2.english_name.should eq("test")
      category2.arabic_name.should eq("بتتش")
      category1.id.should eq(category2.id)
    end

    it "should create new two word category in english and arabic", mohamed: true do
      success, category =
        Category.add_category_to_database_if_not_exists("test test ", " بتتش بتتش ")
      success.should eq(true)
      category.english_name.should eq("test test")
      category.arabic_name.should eq("بتتش بتتش")
    end

    it "Should not create category if arabic name already exists but not english", mohamed: true do
      success, category =
        Category.add_category_to_database_if_not_exists("test", "بتتش")
      success.should eq(true)
      category.arabic_name.should eq("بتتش")
      success, category =
        Category.add_category_to_database_if_not_exists("testing", "بتتش")
      success.should eq(false)
    end

    it "Should not create category if english name already exists but not arabic", mohamed: true do
      success, category =
        Category.add_category_to_database_if_not_exists("test", "بتتش")
      success.should eq(true)
      category.arabic_name.should eq("بتتش")
      success, category =
        Category.add_category_to_database_if_not_exists("test", "بتتش بتتش")
      success.should eq(false)
    end

    it "should create a category after downcasing and stripping", mohamed: true do
      success, category =
        Category.add_category_to_database_if_not_exists("Test ", " بتتش بتتش ")
      success.should eq(true)
      category.english_name.should eq("test")
      category.arabic_name.should eq("بتتش بتتش")
    end

    it "should not create a category if it contains anything other than letters", mohamed: true do
      success, category =
        Category.add_category_to_database_if_not_exists("Test 2", "بتتش 2")
      success.should eq(false)
    end

    it "should not create a category if it contains both english and arabic in one of the names", mohamed: true do
      success, category =
        Category.add_category_to_database_if_not_exists("بتتش test", "بتتش test")
      success.should eq(false)
    end
  end

  describe "Category.sanitize" do
    it "should remove empty tokens",  mohamed: true do
      Category.split_and_sanitize("a,b,,,,,c,d").should =~ ["a", "b", "c", "d"]
    end

    it "should remove tokens with symbols or numbers",  mohamed: true do
      Category.split_and_sanitize("a,b,a1,a!,c,d").should =~ ["a", "b", "c", "d"]
    end

    it "should remove tokens with symbols or numbers",  mohamed: true do
      Category.split_and_sanitize("a,b,a1,a!,c,d").should =~ ["a", "b", "c", "d"]
    end
  end

  describe "Category.get_category_by_name", mohamed: true do
    let(:c1) {
      success, category = Category.add_category_to_database_if_not_exists("test", "بتتش")
      category
    }

    before :each do
      c1
    end

    it "Should find the category by name acording to locale" do
      I18n.locale = :ar
      c = Category.find_by_name_and_locale("بتتش")
      c.id.should eq(c1.id)
      I18n.locale = :en
      c = Category.find_by_name_and_locale("test")
      c.id.should eq(c1.id)
    end

    it "Should not find the category by name if using different locale" do
      I18n.locale = :en
      c = Category.find_by_name_and_locale("بتتش")
      c.should eq(nil)
      I18n.locale = :ar
      c = Category.find_by_name_and_locale("test")
      c.should eq(nil)
    end

  end
end
