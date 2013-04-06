require 'test_helper'

class FollowControllerTest < ActionController::TestCase
  test "should get follow" do
    get :follow
    assert_response :success
  end

  test "should get unfollow" do
    get :unfollow
    assert_response :success
  end

  test "should get listFollowed" do
    get :listFollowed
    assert_response :success
  end

end
