# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'

  resources :users, only: %i[new create]
  resources :empires, only: %i[edit update]
  resources :star_systems, only: %i[edit update]
  resources :buildings, only: %i[create destroy]

  get '/dashboard', to: 'dashboards#index', as: :dashboard

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
