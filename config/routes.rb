# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :announcements, only: %i[show]
      post 'auth/login', to: 'auth#create'
      get 'auth/me', to: 'auth#show'
      post 'auth/register', to: 'users#create'
      resources :categories, only: %i[show create update destroy]
      resources :members, only: %i[index]
      post '/organization/public', to: 'organizations#create'
      resources :testimonials, only: %i[index create]
      resources :users, only: %i[index update destroy]
    end
  end
end
