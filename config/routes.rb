require "sidekiq/web"

Rails.application.routes.draw do
  resources :new_users
  resources :transactions
  resources :budgets
  resources :reports, only: [:index, :new, :create, :show] do
    member do
      get :download
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: "logout"

  get "profile", to: "new_users#show", as: "profile"

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
end
