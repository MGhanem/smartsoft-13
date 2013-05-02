require "spec_helper"

describe "change locale", mohamed: true do
  it "Shows default locale of arabic" do
    get "/"
    I18n.locale.should eq(:ar)
  end

  it "Shows change the default locale when you click on the language link" do
    get "/", locale: :ar
    I18n.locale.should eq(:ar)

    get "/", locale: :en
    I18n.locale.should eq(:en)

    get "/"
    I18n.locale.should eq(:en)
  end
end
