class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token, only: [:create, :new]

  # Redirect user to login page after successful signup
  def after_sign_up_path_for(resource)
    new_user_session_path # Redirects to the login page
  end

  def new
    @user = User.new
    super
    # create a task which send email 
  end

  private

  def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :email, :password, :password_confirmation, :avatar, :remember_me])
   end
   
end