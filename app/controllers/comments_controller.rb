# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    # @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to posts_path(@post), notice: "Comment added."
    else
      # Rails.logger.error @comment.errors.full_messages.join(", ")
      redirect_to posts_path(@post), alert: "Failed to add comment."
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
