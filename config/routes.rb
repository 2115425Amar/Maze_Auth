require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions" }

  resources :posts do
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ] # Add destroy for unliking
  end

  resources :comments do
    resources :likes, only: [ :create, :destroy ]
  end

  # get "profile", to: "users#profile"
  # Custom profile update route
  resource :profile, only: [:show, :update], controller: 'users', action: :profile
  patch 'profile/update', to: 'users#update_profile', as: :update_profile

  resources :reports, only: [ :index ] do
    collection do
      get "download_report"
    end
  end

  resources :manage_users, only: [ :index, :create, :new , :destroy] do
    member do
      patch "toggle_status", to: "manage_users#toggle_status"
    end
    collection do
      get "upload"         # Display the upload form
      post "upload_users"  # Handle the CSV/XLSX upload
    end
  end

  root "home#index"
  # post 'get_posts', to: 'home#index'

    # idekiq Web UI (Dashboard)
    mount Sidekiq::Web => "/sidekiq"
end













# ----------------------------------------------
# namespace :admin do
#   resources :users do
#     member do
#       post 'activate'
#       post 'deactivate'
#     end

#     collection do
#       get 'filter_by_role'
#     end
#   end
#   resources :posts, only: [:index, :show] # Admin can view posts and comments
#   resources :comments, only: [:destroy]   # Admin can delete comments
# end
# ----------------------------------------------------
# namespace :admin do
#   get 'users', to: 'users#index'
#   get 'users/:id', to: 'users#show'
#   post 'users', to: 'users#create'
#   put 'users/:id', to: 'users#update'
#   delete 'users/:id', to: 'users#destroy'
#   post 'users/:id/activate', to: 'users#activate'
#   post 'users/:id/deactivate', to: 'users#deactivate'

#   get 'users/filter_by_role', to: 'users#filter_by_role'

#   get 'posts', to: 'posts#index'
#   get 'posts/:id', to: 'posts#show'

# end


# member Routes
# Purpose: Used to define routes that act on a specific member (a single record) of the resource.
# URL Structure: Includes the :id of the resource in the URL.
# Example: If you have a posts resource, a member route might be used to like a specific post.

# When the action is specific to a single record (e.g., liking a post, toggling the status of a user).

# ---------------------------------
# collection Routes
# Purpose: Used to define routes that act on the entire collection of the resource (not tied to a specific record).
# URL Structure: Does not include the :id of the resource.
# Example: If you have a posts resource, a collection route might be used to search all posts.
  
 