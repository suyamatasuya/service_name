Rails.application.routes.draw do
  get 'privacy_policies/index'
  get 'care_methods/new'
  get 'care_methods/create'
  root 'home#index'

  resources :users, only: [:new, :create, :edit, :update] do
    resources :favourites, only: [:index] # ここを変更
    get :favourites, on: :member  # Use member instead of collection
  end
  resources :user_sessions, only: [:new, :create, :destroy]

  # ネストされたfavouritesのルートを追加
  resources :posts do
    resources :favourites, only: [:create, :destroy]
  end

  resources :symptoms do
    resources :steps, only: [:show, :update, :create], controller: 'symptom_steps' do
      member do
        get :generate_care_methods
      end
    end
  end

  resources :care_methods, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :user_care_histories, only: [:index, :create, :destroy]

  get 'login', to: 'user_sessions#new', as: :login
  delete 'logout', to: 'user_sessions#destroy', as: :logout
  get 'privacy_policy', to: 'privacy_policies#index'
end
