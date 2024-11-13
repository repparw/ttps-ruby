Rails.application.routes.draw do
  devise_for :users

  # Public storefront routes
  root 'storefront#index'
  resources :products, only: [:index, :show]

  # Admin routes
  namespace :admin do
    root 'dashboard#index'
    resources :products do
      member do
        patch :update_stock
      end
    end
    resources :sales do
      member do
        patch :cancel
      end
    end
    resources :users do
      member do
        patch :deactivate
        patch :activate
      end
    end
    resources :categories
  end
end
