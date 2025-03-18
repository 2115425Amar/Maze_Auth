module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def index
      @roles = Role.all
      # @users = User.includes(:roles).order(created_at: :desc).page(params[:page]).per(10)
      @users = User.includes(:roles).order(created_at: :desc)
      @users = @users.joins(:roles).where(roles: { name: params[:role] }) if params[:role].present?
      render 'admin/users/index'
    end

    def show
      @post = Post.includes(:comments, :likes).find_by(id: params[:id])
      redirect_to admin_posts_path, alert: "Post not found." if @post.nil?
    end


    def filter_by_role
      redirect_to admin_users_path(role: params[:role])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        @user.add_role(params[:user][:role_ids]) if params[:user][:role_ids].present?
        # flash[:notice] = "User created successfully."
        redirect_to admin_users_path
      else
        # flash[:alert] = "Failed to create user."
        render :new
      end
    end

    def activate
      @user = User.find(params[:id])
      @user.update(active: true)
      flash.now[:notice] = "#{@user.first_name} activated successfully."
    
      respond_to do |format|
        format.js # This renders `activate.js.erb`
      end
    end
    
    def deactivate
      @user = User.find(params[:id])
      @user.update(active: false)
      flash.now[:notice] = "#{@user.first_name} has been deactivated."
    
      respond_to do |format|
        format.js # This renders `deactivate.js.erb`
      end
    end
    

    private

    def require_admin
      unless current_user.has_role?(:admin)
        flash[:alert] = "You are not authorized to access this page."
        redirect_to root_path
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, role_ids: [])
    end
  end
end
