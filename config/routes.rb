Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy] # Add destroy for unliking
  end

  resources :comments do
    resources :likes, only: [:create, :destroy]
  end

  # namespace :admin do
  #   resources :users, only: [:index, :update, :destroy]
  # end

  namespace :admin do
  resources :users do
    member do
      post 'activate'
      post 'deactivate'
    end
  end
end

  
  # root "home#index"

  root 'home#landing'
  # get 'landing', to: 'home#landing'
  
  # root "posts#index"
end


# devise_for :users
# This sets up Devise authentication routes for the User model.
# It automatically generates routes for actions like sign up, login, logout, and password management.

# controllers: { registrations: 'users/registrations' }
# This tells Devise to use a custom controller for user registration.
# Instead of using Devise's default Devise::RegistrationsController,
# it will use Users::RegistrationsController (which should be located at app/controllers/users/registrations_controller.rb).
