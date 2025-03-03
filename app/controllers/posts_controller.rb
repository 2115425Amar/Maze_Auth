# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  # before_action :authenticate_user!, except: :index
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post, only: %i[show edit update destroy]

  # def index
  #   @posts = Post.includes(:comments).order(created_at: :desc)
  # end

  def index
    if current_user.has_role?(:admin)
      # @posts = Post.all
      @posts = Post.includes(:user, :comments).order(created_at: :desc)
    else
      @posts = Post.where(public: true).or(Post.where(user: current_user)).order(created_at: :desc)end
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
  # else
  #   @comments = @post.comments.order(created_at: :desc) # Ensures latest comments first
  # end
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
    params.require(:post).permit( :description, :public)
  end

  def authorize_post
    unless @post.public? || @post.user == current_user || current_user.has_role?(:admin)
      flash[:alert] = "You are not authorized to view this post."
      redirect_to posts_path
    end
  end

# Finds the post (@post = Post.find(params[:id])).
# Checks if the current user is authorized:
# If the user is an admin, they can proceed.
# If the user is the owner of the post, they can proceed.
# Otherwise, the user is blocked and redirected to root_path with an error message.

end
