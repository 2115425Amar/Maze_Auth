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

  # Handle file upload and process users
  # def upload_users
  #   file = params[:file]
  #   success_count = 0
  #   failure_count = 0

  #   if file.present?
  #     case File.extname(file.original_filename)
  #     when ".csv"
  #       users = CSV.read(file.path, headers: true)
  #     when ".xlsx"
  #       spreadsheet = Roo::Spreadsheet.open(file.path)
  #       users = spreadsheet.parse(headers: true)
  #     else
  #       redirect_to upload_manage_users_path, alert: "Invalid file format!" and return
  #     end

  #     users.each do |row|
  #       user = User.new(row.to_h)
  #       user.password = SecureRandom.hex(8)
        
  #       if user.save
  #         success_count += 1
  #       else
  #         failure_count += 1
  #       end
  #     end

  #     # Send email notification to admin
  #     BulkUserMailer.upload_status(current_user.email, success_count, failure_count).deliver_later

  #     redirect_to manage_users_path, notice: "Users uploaded successfully!"
  #   else
  #     redirect_to upload_manage_users_path, alert: "No file selected!"
  #   end
  # end

  # def upload_users
  #   if params[:file].present?
  #     file_path = params[:file].path
  #     BulkUserUploadJob.perform_later(file_path, current_user.email) # Background job
  #     redirect_to manage_users_path, notice: "Bulk upload in progress. You'll receive an email with the status."
  #   else
  #     redirect_to upload_manage_users_path, alert: "Please select a file."
  #   end
  # end

  def upload_users
    file = params[:file]
  
    if file.present?
      # Save the uploaded file to a permanent location
      filename = "uploaded_users_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      filepath = Rails.root.join("public", "uploads", filename)
  
      File.open(filepath, "wb") do |f|
        f.write(file.read)
      end
  
      # Enqueue the Sidekiq job with the permanent file path
      BulkUserUploadJob.perform_later(filepath.to_s, current_user.email)
  
      redirect_to manage_users_path, notice: "Bulk upload started! You'll receive an email with the status."
    else
      redirect_to manage_users_path, alert: "Please upload a file."
    end
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
