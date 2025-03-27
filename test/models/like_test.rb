require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john12345@example.com",
      phone_number: "1234567877",
      password: "password"
    )
    @post = @user.posts.create!(description: "Test post")
    @like = @post.likes.build(user: @user)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "should belong to a user" do
    @like.user = nil
    assert_not @like.valid?
  end

  test "should belong to a likeable (post or comment)" do
    @like.likeable = nil
    assert_not @like.valid?
  end
end