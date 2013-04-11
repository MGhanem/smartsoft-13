require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get admin_imports_csv" do
    get :admin_imports_csv
    assert_response :success
  end

end
