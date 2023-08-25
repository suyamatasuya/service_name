Rails.application.routes.draw do
  get 'weather/index'
  get 'terms_of_service/index'
  get 'privacy_policies/index'
  get 'care_methods/new'
  get 'care_methods/create'
  root 'home#index'

  resources :users, only: [:new, :create, :edit, :update, :show] do
    resources :favourites, only: [:index] 
  end

  resources :user_sessions, only: [:new, :create, :destroy]
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
  resources :terms_of_service, only: [:index]
  resources :care_records

  namespace :api do
  resources :care_records do
    collection do
      delete :delete_by_symptom
    end

    member do
      post :complete
    end
  end
end

  get 'login', to: 'user_sessions#new', as: :login
  delete 'logout', to: 'user_sessions#destroy', as: :logout
  get 'privacy_policy', to: 'privacy_policies#index'
  get '/care_records/index', to: 'care_records#index'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  get 'weather', to: 'weather#index'
  get 'weather/google_api_key', to: 'weather#google_api_key' 
end
