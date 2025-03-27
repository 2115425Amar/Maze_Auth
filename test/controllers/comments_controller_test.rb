require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should create comment" do
    post comments_url, params: { comment: { content: "Nice post!" } }
    assert_response :redirect
  end
end
