# app/controllers/likes_controller.rb
class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    likeable = find_likeable
    likeable.likes.create(user: current_user)
    redirect_back(fallback_location: root_path)
  end

  private

  def find_likeable
    if params[:post_id]
      Post.find(params[:post_id])
    elsif params[:comment_id]
      Comment.find(params[:comment_id])
    end
  end
end

