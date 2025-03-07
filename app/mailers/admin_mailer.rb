class AdminMailer < ApplicationMailer
  default from: '8601082@gmail.com'

  def bulk_upload_status(admin_email, created_users, failed_users)
    @created_users = created_users
    @failed_users = failed_users

    mail(to: admin_email, subject: "Bulk User Upload Report")
  end
end
