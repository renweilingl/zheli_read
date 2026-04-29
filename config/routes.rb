Rails.application.routes.draw do
  # Root route
  root "pages#home"

  # Login routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "register", to: "users#new"
  post "register", to: "users#create"

  get "dashboard", to: "pages#dashboard"

  resources :files, only: [:show] do
    collection do
      post :upload
      post :upload_img
      post :upload_open_img
    end
  end

  # Admin routes
  namespace :admin do
    resources :accounts, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
      member do
        post :reset_password
      end
    end

    resources :permissions, only: [:index, :show]
    resources :suppliers

    resources :categories
    resources :grades
    resources :chapters

    # Collections management (绘本合辑)
    resources :compilations, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      member do
        get 'books'
        post 'update_books'
      end
    end

    resources :picture_books do
      member do
        get 'chapters'
        get 'new_chapter'
        post 'add_chapter'
        get 'edit_chapter'
        post 'update_chapter'
      end
    end
  end
end
