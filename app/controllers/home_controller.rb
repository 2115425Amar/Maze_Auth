class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token # Skip CSRF token check for API

  def index
  end
  
  # def index
  #   id = params[:id]
  #   puts "id: #{id}"
  #    posts = Post.all
  #    if id.present?
  #      posts = posts.where(id: id)
  #    end
  #    render json: { data: posts, message: "Data is fetched successfully" }, status: :ok
  # end

  # def create
  #   description = params[:description]
  #   if description.blank?
  #     render json: { message: "Description can't be blank" }, status: 400
  #   end
  #   Post.create(description: params[:description])
  #   render json: { message: "Post is created successfully" }, status: :ok
  # end
end
