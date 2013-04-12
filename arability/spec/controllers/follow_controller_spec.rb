# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers

describe FollowController do
  include Devise::TestHelpers

    let(:word) {word = Keyword.new
      word.name = "testkeyword"
      word.save
      word
    }
      

    it "should make devloper follow a word" do
      developer = create_logged_in_developer()
      sign_in(developer.gamer)
      get :follow, :keyword_id => follow
      followed = developer.keyword_ids.include? word.id
      expect(followed).to eq (true)
    end
end
