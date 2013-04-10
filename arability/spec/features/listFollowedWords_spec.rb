require "spec_helper"
include Warden::Test::Helpers 
describe  do
  let(:gamer){
  gamer = Gamer.new
    gamer.username = "Nourhan"
    gamer.country = "Egypt"
    gamer.education_level = "high"
    gamer.gender = "female"
    gamer.date_of_birth = "1993-03-23"
    gamer.email = "mohamedtamer92@gmail.com"
    gamer.password = "1234567"
    gamer.save
    gamer
  }

  let(:developer){
    developer = Developer.new
    developer.first_name = "Mostafa"
    developer.last_name = "Hassaan"
    developer.gamer_id = gamer.id 
    developer.save
    developer
  }

  let(:word) {word = Keyword.new
    word.name = "testkeyword"
    word.save
    word
  }
  let(:word2) {word = Keyword.new
    word.name = "testkeywords"
    word.save
    word
  }
  let(:word3) {word = Keyword.new
    word.name = "testkeywordss"
    word.save
    word
  }

  

  it "developer should be able to see a list of followed words" do
    # visit root_path
    # click_link I18n.t(:sign_in)

    # fill_in 'gamer_email', :with => gamer.email
    # fill_in 'gamer_password', :with => gamer.password
    # page

    login_as gamer

    visit list_followed_words_path

    page.should have_content(word.name)
    page.should have_content(word2.name)
    page.should have_content(word3.name)    
  end
end