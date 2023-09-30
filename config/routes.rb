# frozen_string_literal: true

Rails.application.routes.draw do
  get 'care_settings/new'
  get 'care_settings/create'
  root 'home#index'

  resources :users, only: %i[new create edit update show] do
    resources :favourites, only: [:index]
  end

  resources :user_sessions, only: %i[new create destroy]
  
  resources :posts do
    resources :favourites, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end

  resources :symptoms do
    resources :steps, only: %i[show update create], controller: 'symptom_steps' do
      member do
        get :generate_care_methods
      end
    end
  end

  resources :care_methods, only: %i[index new create show edit update destroy]
  resources :user_care_histories, only: %i[index create destroy]
  resources :terms_of_service, only: [:index]
  resources :care_records
  resources :care_settings, only: [:new, :create]

  resources :weather, only: [:index] do
    collection do
      get :google_api_key
    end
  end

  resources :privacy_policies, only: [:index]
  
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
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
end
