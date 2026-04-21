Rails.application.routes.draw do
  # Root route
  root "pages#home"

  # Login routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Registration routes
  get "register", to: "users#new"
  post "register", to: "users#create"

  # Dashboard
  get "dashboard", to: "pages#dashboard"

  # Admin routes
  namespace :admin do
    resources :accounts, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
      member do
        post :reset_password
      end
    end

    resources :permissions, only: [:index, :show]
    resources :suppliers

    resources :categories, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      member do
        patch :toggle_active
      end
      collection do
        get :statistics
        post :batch_action
      end
    end

    resources :contents, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      collection do
        post :upload
        post :upload_cover
      end
    end

    resources :books, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      member do
        post :publish
        post :offline
        post :toggle_status
        post :toggle_lock
      end
      collection do
        post :upload_cover
        post :upload_intro_image
      end
    end

  end
end
