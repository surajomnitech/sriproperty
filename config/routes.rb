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
    resources :user_package_purchases do
      member do
        patch :approve_payment
        patch :cancel_purchase
        delete 'remove_document/:document_id', action: :remove_document, as: :remove_document
      end
    end
  end

  resource :profile, only: [:show, :edit, :update]
  
  # Root path
  root "home#index"
end
