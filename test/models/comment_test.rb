require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john11@example.com",
      phone_number: "1234567890",
      password: "password"
    )
    @post = @user.posts.create!(description: "Test post")
    @comment = @post.comments.build(content: "Nice post!", user: @user)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "should require content" do
    @comment.content = nil
    assert_not @comment.valid?
  end

  test "should belong to a post" do
    @comment.post = nil
    assert_not @comment.valid?
  end

  test "should belong to a user" do
    @comment.user = nil
    assert_not @comment.valid?
  end
end
