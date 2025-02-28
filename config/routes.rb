Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # root 'home#landing'
  # root "posts#index"

  resources :posts do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create, :destroy]
  end

  # resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy]


  # get 'posts', to: 'posts#index'
  # get 'landing', to: 'home#landing'

  # Defines the root path route ("/")
  root "posts#index"
  # root 'sessions#new'
end
