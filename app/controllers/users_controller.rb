class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [:index, :manage_users, :toggle_status, :new, :create, :report_users]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def manage_users
    @users = User.page(params[:page]).per(10)
  end

  def report_users
    @users = User.page(params[:page]).per(10)
  end

  # ✅ Allow admins to add new users
  def new
    @user = User.new
  end
  

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User successfully created."
      redirect_to manage_users_path
    else
      flash[:alert] = "Failed to create user."
      render :new
    end
  end

  def update_status
    @user = User.find(params[:id])
    if @user.update(active: params[:active])
      flash[:notice] = "User status updated successfully."
    else
      flash[:alert] = "Failed to update user status."
    end

    respond_to do |format|
      format.js   # This triggers update_status.js.erb
    end
  end

  def toggle_status
    @user = User.find(params[:id])
    @user.update(active: !@user.active)

    # redirect_to manage_users_path, notice: "User successfully updated."

    respond_to do |format|
      format.html { redirect_to manage_users_path, notice: "User successfully updated." }
      format.js   # ✅ This will render `toggle_status.js.erb`
    end

  end

  def profile
    @user = current_user
  end

  private

  def check_admin
    redirect_to root_path, alert: 'Access denied' unless current_user.has_role?(:admin)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, role_ids: [])
  end
end
