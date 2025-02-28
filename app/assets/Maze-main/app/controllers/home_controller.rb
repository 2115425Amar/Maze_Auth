class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[landing]
  def landing
  end
end
