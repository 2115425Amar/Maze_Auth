class PostsController < ApplicationController
  def create
    Post.create(description: params[:description])
    render json: { message: "Post is created successfully" }, status: :ok
  end
end
