# /home/hp/Desktop/auth2/devise_auth/app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: "amar8601082@gmail.com"  # email will be sent from this email address

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Our Platform!")
  end
end
