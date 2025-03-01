Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  
  root 'home#landing'
  get 'landing', to: 'home#landing'
  
  # Defines the root path route ("/")
  # root "posts#index"
end
