Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  root 'home#landing'
  # get 'landing', to: 'home#landing'
  
  # Defines the root path route ("/")
  # root "posts#index"
  # root 'sessions#new'
end
