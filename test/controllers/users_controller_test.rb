require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = User.create!(
      first_name: "Admin",
      last_name: "User",
      email: "admin@example.com",
      phone_number: "1122334455",
      password: "adminpassword",
      password_confirmation: "adminpassword"
    )
    @admin.add_role(:admin) # Assigns admin role dynamically
    sign_in @admin
  end

  test "should get profile" do
    get profile_path
    assert_response :success
  end

  test "should update profile" do
    patch update_profile_path, params: { user: { first_name: "NewName" } }
    assert_redirected_to profile_path
    @user.reload
    assert_equal "NewName", @user.first_name
  end

  test "should not allow non-admins to access index" do
    get users_path
    assert_redirected_to root_path
    assert_equal "Access denied", flash[:alert]
  end

  test "should allow admin to access index" do
    sign_out @user
    sign_in @admin
    get users_path
    assert_response :success
  end

  test "should allow admin to manage users" do
    sign_out @user
    sign_in @admin
    get manage_users_path
    assert_response :success
  end

  test "should allow admin to report users" do
    sign_out @user
    sign_in @admin
    get report_users_path
    assert_response :success
  end

  test "should prevent non-admins from managing users" do
    get manage_users_path
    assert_redirected_to root_path
    assert_equal "Access denied", flash[:alert]
  end

  test "should prevent non-admins from reporting users" do
    get report_users_path
    assert_redirected_to root_path
    assert_equal "Access denied", flash[:alert]
  end
end
