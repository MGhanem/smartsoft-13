require 'spec_helper'

describe "ChangeLocales", mohamed: true do
  it "changes current locale when he clicks the locale button" do
    visit root_path
    click_link I18n.t(:english)
    I18n.locale.should eq(:en)

    click_link I18n.t(:arabic)
    I18n.locale.should eq(:ar)
  end
end
