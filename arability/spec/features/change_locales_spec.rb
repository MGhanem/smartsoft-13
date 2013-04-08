require 'spec_helper'

describe "ChangeLocales" do
  it "changes current locale when he clicks the locale button" do
    visit root_path
    click_link I18n.t(:english)
    I18n.locale.should eq(:en)

    click_link "Arabic"
    I18n.locale.should eq(:ar)
  end
end
