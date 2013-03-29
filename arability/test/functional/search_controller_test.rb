require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get search results" do
    get :search
    assert_response :success
  end

end
