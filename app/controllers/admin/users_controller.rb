class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    # This line of code fetches all users from the database while preloading their associated posts to optimize performance.
    # @users = User.all
    @users = User.includes(:posts).all
    @posts = Post.includes(:user, :comments).order(created_at: :desc)
    render 'admin/users/user_management'
  end


  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.add_role(params[:user][:role_ids]) if params[:user][:role_ids].present?
      flash[:notice] = "User created successfully."
      redirect_to admin_users_path
    else
      flash[:alert] = "Failed to create user."
      render :new
    end
  end
  


  def update
    user = User.find(params[:id])
    if user.update(user_params)
      flash[:notice] = "User updated successfully"
    else
      flash[:alert] = "Failed to update user"
    end
    redirect_to admin_users_path
  end


  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:notice] = "User deleted successfully"
    redirect_to admin_users_path
  end

  def activate
    user = User.find(params[:id])
    user.update(active: true)
    flash[:notice] = "#{user.first_name} activated successfully."
    redirect_to admin_users_path
  end
  
  def deactivate
    user = User.find(params[:id])
    user.update(active: false)
    flash[:notice] = "#{user.first_name} has been deactivated."
    redirect_to admin_users_path
  end
  


  private

  def require_admin
    unless current_user.has_role?(:admin)
      flash[:alert] = "You are not authorized to access this page"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, role_ids: [])
  end
end
