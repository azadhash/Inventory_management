# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  root 'sessions#new'
  get '/dashboard', to: 'homes#welcome'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  delete '/logout', to: 'sessions#destroy'
  get '/authenticate', to: 'sessions#authenticate'
  get '/categories/fetch', to: 'categories#fetch_data'
  patch '/notifications/mark_read', to: 'notification#mark_read'

  resources :users do
    collection do
      get :search
    end
  end
  resources :brands do
    collection do
      get :search
    end
  end
  resources :categories do
    collection do
      get :search
      get :storage
    end
  end
  resources :issues do
    collection do
      get :search
    end
  end
  resources :items do
    collection do
      get :search
      post :clear_filter
    end
  end
  resources :notification
  match '*unmatched', to: 'application#not_found_method', via: :all,
                      constraints: lambda { |req|
                                     !req.path.match(%r{\A/rails/active_storage/})
                                   }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

# rubocop:enable Metrics/BlockLength
