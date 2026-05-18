Rails.application.routes.draw do
  # Health check for kamal-proxy
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "pages#home"

  # Login routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  #get "register", to: "users#new"
  #post "register", to: "users#create"
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
    resources :options, only: [:index]
    resources :authors

    resources :accounts, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
      member do
        post :reset_password
      end
    end

    resources :permissions, only: [:index, :show]
    resources :suppliers

    resources :categories do
      resources :category_subs
      member do
        get :subs
      end
    end

    resources :book_levels

    resources :grades do
      resources :recommends, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        member do
          post :toggle_status
        end
        collection do
          post :upload_cover
        end

        resources :content_groups do
          resources :contents
        end
      end
    end

    #resources :chapters
    # Collections management (绘本合辑)
    resources :compilations, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      member do
        get 'books'
        post 'update_books'
      end
    end

    resources :picture_books do
      resources :book_chapters do
        post 'update_sn', on: :collection
      end
    end

    #resources :picture_books do
      #member do
      #  get 'chapters'
      #  get 'new_chapter'
      #  post 'add_chapter'
      #  get 'edit_chapter'
      #  post 'update_chapter'
      #end
    #end
  end

  namespace :operator do
    resources :packages
  end

  resources :push_notifications, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      post :send_push
    end
  end
end
