Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:new, :create,:edit, :update]
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :symptoms do
    resources :steps, only: [:show, :update], controller: 'symptom_steps'
  end
  
  
  resources :boards, only: [:index, :show, :new, :create]

  get 'login', to: 'user_sessions#new', as: :login
  delete 'logout', to: 'user_sessions#destroy', as: :logout
end
