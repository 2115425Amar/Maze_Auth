class ApplicationController < ActionController::Base
  # before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    root_path
    # posts_path
    # login_path # Change this to the page you want to redirect to after login
  end
end
