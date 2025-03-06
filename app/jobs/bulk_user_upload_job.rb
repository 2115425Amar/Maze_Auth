require 'csv'
require 'roo'

class BulkUserUploadJob < ApplicationJob
  queue_as :default

  def perform(file_path, admin_email)
    file = Roo::Spreadsheet.open(file_path)
    sheet = file.sheet(0)

    created_users = []
    failed_users = []

    (2..sheet.last_row).each do |i|
      row = sheet.row(i)
      user_data = {
        first_name: row[0],
        last_name: row[1],
        email: row[2],
        phone_number: row[3],
        password: SecureRandom.hex(8)
      }

      user = User.new(user_data)
      if user.save
        user.add_role(row[4]) if row[4].present?
        created_users << user
      else
        failed_users << { email: row[2], errors: user.errors.full_messages }
      end
    end

    # Send email to admin
    AdminMailer.bulk_upload_status(admin_email, created_users, failed_users).deliver_now
  end
end
