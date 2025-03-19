# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: "Comment added!"
    else
      # flash[:alert] = "Comment could not be created"
      redirect_to root_path
    end

   
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
