# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers

describe FollowController do

    let(:word) {word = Keyword.new
      word.name = "testkeyword"
      word.save
      word
    }
      

    it "should make devloper follow a word" do
      d = create_logged_in_developer
      login_gamer(d.gamer)
      get :follow, :keyword_id => word.id
      followed = d.keyword_ids.include? word.id
      expect(followed).to eq (true)
    end

    it "should make devloper unfollow a word" do
      d = create_logged_in_developer
      login_gamer(d.gamer)
      get :unfollow, :keyword_id => word.id
      unfollowed = d.keyword_ids.include? word.id
      expect(unfollowed).to eq (false)
    end
end

