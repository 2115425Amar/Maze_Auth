class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :authenticate_user!
  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_posts_path   # redirect to admin view
    else
      posts_path    # redirect to user view
    end
  end
end
