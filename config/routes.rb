Rails.application.routes.draw do
  resources :new_users
  resources :transactions
  resources :budgets

  get "up" => "rails/health#show", as: :rails_health_check

  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy", as: "logout"
  
  get "profile", to: "new_users#show", as: "profile"
  # Ensure this route is correct:
  # get "new", to: "new_users#new"  # Maps "/index" to NewUsersController#index
end
