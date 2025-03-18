  # /home/hp/Desktop/auth2/devise_auth/app/controllers/users_controller.rb
  class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, only: [ :index, :manage_users,  :new,  :report_users ]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def profile
    @user = current_user
  end

  def update_profile
    @user = current_user

    if @user.update(user_params)
      # Handle Avatar Upload
      if params[:user][:avatar].present?
        response = Cloudinary::Uploader.upload(params[:user][:avatar], folder: "avatars")
        @user.update(avatar_public_id: response["public_id"])
      end

      bypass_sign_in(@user) if params[:user][:password].present? # Keep user signed in after password update
      # flash[:notice] = "Profile updated successfully"
      redirect_to profile_path
    else
      # flash[:alert] = "Failed to update profile"
      render :profile
    end
  end


  def manage_users
    @users = User.page(params[:page]).per(10)
  end

  def report_users
    @users = User.page(params[:page]).per(10)
  end
 

  private

  def check_admin
    redirect_to root_path, alert: "Access denied" unless current_user.has_role?(:admin)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation,  :avatar, role_ids: [])
  end
  end
