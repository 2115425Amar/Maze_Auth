class CommentsController < ApplicationController
  before_action :set_post

  def create
    @user = current_user

    @comment = Comment.new(
      post_id: @post.id,
      user_id: @user.id,
      data: params[:data]
    )
    # @comment = @post.comments.build(comment_params)
    if @comment.save
      redirect_to request.referer, notice: "Comment was successfully created."
    else
      redirect_to request.referer, alert: "Comment was not created."
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
