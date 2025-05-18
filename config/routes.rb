require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web => '/sidekiq'

  root "home#index"

  resources :users, only: [:new, :create]
  resources :empires, only: [:edit, :update]

  get '/dashboard', to: 'dashboards#index', as: :dashboard

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
