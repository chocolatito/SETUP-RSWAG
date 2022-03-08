# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'auth/register', to: 'users#create'
      post 'auth/login', to: 'auth#create'
      resources :categories, only: %i[create update destroy]
      post '/organization/public', to: 'organizations#create'
      resources :users, only: %i[update index]
    end
  end
end
