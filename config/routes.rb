Rails.application.routes.draw do
  root 'home#index'
  
  resources :users, only: [:new, :create]
  resources :user_sessions, only: [:new, :create, :destroy]
  
  get 'login', to: 'user_sessions#new', as: :login
  delete 'logout', to: 'user_sessions#destroy', as: :logout

end