class BulkUserUploadJob < ApplicationJob
  queue_as :default

  def perform(file_path, admin_email)
    users = []
    errors = []

    begin
      case File.extname(file_path)
        # Iterates through each row and creates a new User with a randomly generated password.
      when ".csv"
        CSV.foreach(file_path, headers: true) do |row|
          user = User.new(row.to_hash.merge(password: Devise.friendly_token[0, 10]))
          # Stores successfully created users and logs errors for failed ones.
          if user.save
            users << user
          else
            errors << { row: row.to_h, errors: user.errors.full_messages || [] }
          end
        end
      when ".xlsx"
        xlsx = Roo::Excelx.new(file_path)
        xlsx.each_row_streaming(offset: 1) do |row|
          user = User.new(
            name: row[0].value,
            email: row[1].value,
            phone_number: row[2].value,
            password: Devise.friendly_token[0, 10]  # Auto-generate password
          )
          if user.save
            users << user
          else
            errors << { row: row.map(&:value), errors: user.errors.full_messages || [] }
          end
        end
      end
    rescue => e
      errors << { error: "Exception raised: #{e.message}" }
    ensure
      # Sends an email report to the admin after processing.
      AdminMailer.bulk_upload_status(admin_email, users.count, errors).deliver_later
      File.delete(file_path) if File.exist?(file_path) # Clean up the file after processing
    end
  end
end
