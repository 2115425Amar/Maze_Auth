class ManageUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users = User.where.not(id: current_user.id).page(params[:page])
    # @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(8)

    if @user.save
      assign_roles(@user)
      redirect_to manage_users_path, notice: "User created successfully!"
    else
      flash.now[:alert] = "User creation failed!"
      render :new, status: :unprocessable_entity
    end
  end



  def toggle_status
    user = User.find(params[:id])
    user.update(active: !user.active?)
    # respond_to do |format|
    #   format.html { redirect_to manage_users_path, notice: "User status updated." }
    #   format.js   # For AJAX support (optional)
    # end
    redirect_to manage_users_path, notice: "User status updated!"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
  end

  def assign_roles(user)
    roles = params[:user][:roles]
    roles.each { |role| user.add_role(role) } if roles.present?
  end

  def authorize_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
