# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(:comments).order(created_at: :desc)
  end

  def show
    @post = Post.includes(:comments).find_by(id: params[:id])
    if @post.nil?
      redirect_to posts_path, alert: "Post not found."
    end
  end

  def edit
    @post = current_user.posts.find_by(id: params[:id])
    if @post.nil?
      redirect_to posts_path, alert: "You can only edit your own posts."
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post created successfully."
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "Post updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted."
  end

  private

  def set_post
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to posts_path, alert: "Post not found." if @post.nil?
  end

  def post_params
    params.require(:post).permit(:title, :description, :public)
  end
end
