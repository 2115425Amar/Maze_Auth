class ApplicationController < ActionController::Base
  # before_action :authenticate_user!       # Ensure user is authenticated
  def after_sign_in_path_for(resource)
    posts_path
  end
end
