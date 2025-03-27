require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      first_name: "John12",
      last_name: "Doe12",
      email: "john12@example.com",
      phone_number: "1234567888",
      password: "password",
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should require first name" do
    @user.first_name = nil
    assert_not @user.valid?
  end

  test "should require last name" do
    @user.last_name = nil
    assert_not @user.valid?
  end

  test "should require a valid email" do
    @user.email = "invalid-email"
    assert_not @user.valid?
  end

  test "should require unique email" do
    @user.save
    user2 = @user.dup
    assert_not user2.valid?
  end
end
