class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token, only: [:create, :new]

  # overrode the create method provided by Devise:
  def create
    super do |user|
      if user.persisted?  # Only send email if user was successfully created
        send_welcome_email(user)
      end
    end
  end

  def after_sign_up_path_for(resource)
    new_user_session_path # Redirects to the login page
  end

  private

  def send_welcome_email(user)
    begin
      UserMailer.welcome_email(user).deliver_later
    rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED => e
      Rails.logger.error "Sidekiq is not running or Redis is unavailable: #{e.message}"
      UserMailer.welcome_email(user).deliver_now # Fallback to synchronous email sending
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :email, :password, :password_confirmation, :avatar, :remember_me])
  end
end
