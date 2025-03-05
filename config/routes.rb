Rails.application.routes.draw do

  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions'}

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy] # Add destroy for unliking
  end

  resources :comments do
    resources :likes, only: [:create, :destroy]
  end

  resources :users, only: [:index, :new, :create] do
    member do
      patch 'toggle_status' # Toggles active status
    end
    collection do
      get 'manage_users'
    end
  end
  
  # /users/manage_users

  root 'home#landing'

  get '/landing', to: 'home#landing'
  get 'feed', to: 'posts#index', as: :feed
  get 'profile', to: 'users#profile'
  get 'manage_users', to: 'users#manage_users'
  get 'reports', to: 'users#report_users'

  # get 'manage_users', to: 'users#index' # Admin-only

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
  
  #   delete 'comments/:id', to: 'comments#destroy'
  # end

end



# devise_for :users
# This sets up Devise authentication routes for the User model.
# It automatically generates routes for actions like sign up, login, logout, and password management.

# controllers: { registrations: 'users/registrations' }
# This tells Devise to use a custom controller for user registration.
# Instead of using Devise's default Devise::RegistrationsController,
# it will use Users::RegistrationsController (which should be located at app/controllers/users/registrations_controller.rb).
