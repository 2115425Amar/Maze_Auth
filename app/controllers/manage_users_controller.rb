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


  # Display the file upload form
  def upload
  end




  # def upload_users
  #   file = params[:file]
  #   if file.present?
  #     if  file.content_type == "text/csv" || file.content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

  #     # Save the uploaded file to a persistent location
  #     saved_file_path = Rails.root.join("tmp", "bulk_upload_#{Time.now.to_i}_#{file.original_filename}")
  #     File.open(saved_file_path, "wb") { |f| f.write(file.read) }

  #       BulkUserUploadJob.perform_later(file.path, current_user.email)
  #       redirect_to manage_users_path, notice: "Bulk user upload has started. You will receive an email with the status."
  #     else
  #       redirect_to upload_manage_users_path, alert: "Invalid file format. Please upload a CSV or XLSX file."
  #     end
  #   else
  #     redirect_to upload_manage_users_path, alert: "No file selected."
  #   end
  # end

  def upload_users
    file = params[:file]
    if file.present?
      if file.content_type == "text/csv" || file.content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        # Save the uploaded file to a persistent location
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

  def bulk_upload
    if params[:file].present?
      file_path = params[:file].path
      BulkUserUploadJob.perform_later(file_path, current_user.email)
      redirect_to manage_users_path, notice: "Bulk upload in progress. You'll receive an email with the status."
    else
      redirect_to manage_users_path, alert: "Please upload a file."
    end
  end
end
