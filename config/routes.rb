Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  devise_for :users

  # Public routes namespace
  scope module: :public do
    root "products#index"
    resources :products, only: %i[index show]
    resources :categories, only: %i[index show]
  end

  # Admin namespace
  namespace :admin do
    root "dashboard#index"
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
