class BulkUserUploadJob < ApplicationJob
  queue_as :default

  def perform(file_path, admin_email)
    return unless File.exist?(file_path) # Ensure the file exists

    success_count = 0
    failure_count = 0

    CSV.foreach(file_path, headers: true) do |row|
      user = User.new(row.to_h)
      user.password = SecureRandom.hex(8)

      if user.save
        success_count += 1
      else
        failure_count += 1
      end
    end

    # Send email notification
    BulkUserMailer.upload_status(admin_email, success_count, failure_count).deliver_now

    # Optionally, delete the file after processing
    File.delete(file_path) if File.exist?(file_path)
  end
end
