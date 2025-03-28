class ManageUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users = User.where.not(id: current_user.id).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    generated_password = SecureRandom.hex(8)  # Generate a random password
    @user.password = generated_password

    if @user.save
      assign_roles(@user)

      begin
        UserMailer.byadmin_welcome_email(@user, generated_password).deliver_later  # Sends the email immediately.
      rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED => e
        Rails.logger.error "Sidekiq is not running or Redis is unavailable: #{e.message}"
        UserMailer.byadmin_welcome_email(@user, generated_password).deliver_now    # Enqueues the email to be sent asynchronously.  Adds the email job to a queue.
      end

      redirect_to manage_users_path, notice: "User created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end


  def destroy
    user = User.find(params[:id])
    if user.destroy
      redirect_to manage_users_path, notice: "User deleted successfully."
    else
      redirect_to manage_users_path, alert: "Failed to delete user."
    end
  end

  def toggle_status
    user = User.find(params[:id])
    user.update(active: !user.active?)

    redirect_to manage_users_path, notice: "User status updated!"
  end

  # Display the file upload form
  def upload
  end

  def upload_users
    file = params[:file]
    if file.present?
      if file.content_type == "text/csv" || file.content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        # Save the uploaded file to a persistent location Saves the file temporarily in the tmp directory.
        saved_file_path = Rails.root.join("tmp", "bulk_upload_#{Time.now.to_i}_#{file.original_filename}")
        File.open(saved_file_path, "wb") { |f| f.write(file.read) }

        # Pass the saved file path to the Sidekiq job
        BulkUserUploadJob.perform_later(saved_file_path.to_s, current_user.email)
        redirect_to manage_users_path, notice: "Bulk user upload has started. You will receive an email with the status."
      else
        redirect_to upload_manage_users_path, alert: "Invalid file format. Please upload a CSV or XLSX file."
      end
    else
      redirect_to upload_manage_users_path, alert: "No file selected."
    end
  end


  #   The uploaded file is now saved to the /tmp folder with a unique filename.
  # ✅ File.open ensures the file data is securely written before passing it to Sidekiq.
  # ✅ The saved file's path is passed to the BulkUserUploadJob

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
