Rails.application.routes.draw do
  root to: redirect('/login')
  get '/dashboard', to: 'homes#welcome'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/logout', to: 'sessions#destroy'
  get '/authenticate', to: 'sessions#authenticate'
  get '/notifications/count', to: 'notification#count'
  get '/categories/fetch', to: 'categories#fetch_data'
  post '/notifications/mark_read', to: 'notification#mark_read' 
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
    end  
  end
  resources :notification
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
