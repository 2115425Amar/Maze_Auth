  # /home/hp/Desktop/auth2/devise_auth/app/controllers/users_controller.rb
  class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [ :index, :manage_users, :toggle_status, :new,  :report_users ]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def profile
    @user = current_user
  end

  def manage_users
    @users = User.page(params[:page]).per(10)
  end

  def report_users
    @users = User.page(params[:page]).per(10)
  end

  def update_status
    @user = User.find(params[:id])
    if @user.update(active: params[:active])
      flash[:notice] = "User status updated successfully."
    else
      flash[:alert] = "Failed to update user status."
    end

    respond_to do |format|
      format.js
    end
  end

  def toggle_status
    @user = User.find(params[:id])
    @user.update(active: !@user.active)

    respond_to do |format|
      format.html { redirect_to manage_users_path, notice: "User successfully updated." }
      format.js
    end
  end

  private

  def check_admin
    redirect_to root_path, alert: "Access denied" unless current_user.has_role?(:admin)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, role_ids: [])
  end
  end
