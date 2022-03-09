# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'auth/login', to: 'auth#create'
      get 'auth/me', to: 'auth#show'
      post 'auth/register', to: 'users#create'
      resources :categories, only: %i[show create update destroy]
      post '/organization/public', to: 'organizations#create'
      resources :users, only: %i[index update]
    end
  end
end
