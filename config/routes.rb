require "sidekiq/web"
Rails.application.routes.draw do
  get "manage_users/index"
  get "manage_users/toggle_status"

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

  resources :manage_users, only: [ :index, :create, :new ] do
    member do
      patch "toggle_status", to: "manage_users#toggle_status"
    end
    collection do
      # post 'bulk_upload'
      get "upload"         # Display the upload form
      post "upload_users"  # Handle the CSV/XLSX upload
    end
  end

  resources :reports, only: [ :index ] do
    collection do
      get "download_report"
    end
  end

  # /users/manage_users

  root "home#index"
  get "/landing", to: "home#landing"
  get "profile", to: "users#profile"

    # get 'feed', to: 'posts#index', as: :feed
    # get 'test_xlsx_report', to: 'reports#test_xlsx_report'

    # ---------- for sidekiq ui -------------------
    # authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  # end
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




# devise_for :users
# This sets up Devise authentication routes for the User model.
# It automatically generates routes for actions like sign up, login, logout, and password management.

# controllers: { registrations: 'users/registrations' }
# This tells Devise to use a custom controller for user registration.
# Instead of using Devise's default Devise::RegistrationsController,
# it will use Users::RegistrationsController (which should be located at app/controllers/users/registrations_controller.rb).
