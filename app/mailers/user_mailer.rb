class UserMailer < ApplicationMailer
  default from: "amar8601082@gmail.com"  # email will be sent from this email address

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Our Platform!")
  end
end
