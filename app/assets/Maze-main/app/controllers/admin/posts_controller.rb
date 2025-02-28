class Admin::PostsController < AdminController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.includes(:comments).order(created_at: :desc)# .page(params[:page]).per(10)
  end

  def create
    @user = current_user
    @post = Post.new(
      user_id: @user.id,
      description: params[:description],
      public: params[:public]
    )
    if @post.save
      redirect_to admin_posts_path, notice: "Post was successfully created."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def show
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new   # This is for the form in the show
  end

  def edit
  end

  def update
    if @post.update(
      description: params[:description],
      public: params[:public]
    )
      redirect_to admin_posts_path, notice: "Post was successfully updated."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "Post was successfully destroyed."
  end

  private

  def authorize_admin
    redirect_to root_path, notice: "Not authorized to enter!!!" unless current_user.admin?
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
