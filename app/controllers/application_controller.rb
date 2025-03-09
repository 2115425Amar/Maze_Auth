class ApplicationController < ActionController::Base
    # before_action :authenticate_user!       # Ensure user is authenticated
  
  def after_sign_in_path_for(resource)
    posts_path
  end

  def require_admin
    unless current_user.has_role?(:admin)
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end

  end
  


