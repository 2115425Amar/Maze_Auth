class UserMailer < ApplicationMailer
  default from: 'your-email@yourdomain.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Our Platform!")
  end
end
