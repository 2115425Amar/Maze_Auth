require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      first_name: "John12",
      last_name: "Doe12",
      email: "john12@example.com",
      phone_number: "1234567888",
      password: "password",
    )
    @post = @user.posts.build(description: "This is a test post")
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "should require a description" do
    @post.description = nil
    assert_not @post.valid?
  end

  test "should belong to a user" do
    @post.user = nil
    assert_not @post.valid?
  end
  
end
