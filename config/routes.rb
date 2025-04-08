Rails.application.routes.draw do
  # Authentication routes
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # Admin routes
  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :users
    resources :properties
    resources :phone_numbers
    resources :packages
  end

  resource :profile, only: [:show, :edit, :update]
  
  # Root path
  root "home#index"
end
