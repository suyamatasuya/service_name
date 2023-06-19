Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:new, :create, :edit, :update]
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :symptoms do
    resources :steps, only: [:show, :update, :create], controller: 'symptom_steps'
  end  
  resources :posts

  get 'login', to: 'user_sessions#new', as: :login
  delete 'logout', to: 'user_sessions#destroy', as: :logout
end
