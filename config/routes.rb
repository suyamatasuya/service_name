Rails.application.routes.draw do
  get 'care_methods/new'
  get 'care_methods/create'
  root 'home#index'

  resources :users, only: [:new, :create, :edit, :update]
  resources :user_sessions, only: [:new, :create, :destroy]
  
  resources :symptoms do
    resources :steps, only: [:show, :update, :create], controller: 'symptom_steps' do
      member do
        get :generate_care_methods
      end
    end
  end
  
  resources :posts
  resources :care_methods, only: [:index, :new, :create, :show, :edit, :update, :destroy]

  get 'login', to: 'user_sessions#new', as: :login
  delete 'logout', to: 'user_sessions#destroy', as: :logout
end
