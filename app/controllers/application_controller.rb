class ApplicationController < ActionController::Base
  # before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # Redirect to login page after logout
  end

  def require_admin
    unless current_user.has_role?(:admin)
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
  
end
