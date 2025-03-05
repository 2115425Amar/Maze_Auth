module Admin
  class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @users = User.all
      @posts = Post.includes(:user, :comments, :likes).order(created_at: :desc)
      # render 'admin/users/index
    end

    def show
      @post = Post.includes(:comments, :likes).find_by(id: params[:id])
      redirect_to admin_posts_path, alert: "Post not found." if @post.nil?
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


    private

    def require_admin
      unless current_user.has_role?(:admin)
        flash[:alert] = "You are not authorized to access this page."
        redirect_to root_path
      end
    end
  end
end
