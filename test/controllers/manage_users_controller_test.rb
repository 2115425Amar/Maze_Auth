require "test_helper"

class ManageUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get manage_users_index_url
    assert_response :success
  end

  test "should get toggle_status" do
    get manage_users_toggle_status_url
    assert_response :success
  end
end
