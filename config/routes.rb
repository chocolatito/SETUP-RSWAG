# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'auth/login', to: 'auth#create'
      get 'auth/me', to: 'auth#show'
      post 'auth/register', to: 'users#create'
      resources :categories, only: %i[create update destroy]
      post '/organization/public', to: 'organizations#create'
<<<<<<< HEAD
      resources :users, only: %i[update index]
=======
      resources :users, only: %i[index update]
>>>>>>> 08f2285 (feat OT-151-34: add endpoint authenticated user)
    end
  end
end
