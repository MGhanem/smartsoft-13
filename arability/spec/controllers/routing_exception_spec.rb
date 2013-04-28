require "spec_helper"
require "request_helpers"
include RequestHelpers

describe ApplicationController do
  it "should redirect to home page when an invalid url is thrown" do
    d = create_logged_in_developer
    login_gamer(d.gamer)
    redirect_to "unavailble_url"
    path = request.path
    expect(path).to eq("")
  end
end
