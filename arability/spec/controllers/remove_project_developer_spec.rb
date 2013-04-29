# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers

describe FollowController do
  include Devise::TestHelpers

it "should make devloper remove a project shared with him" do
      developer = create_logged_in_developer()
      sign_in(developer.gamer)
  end