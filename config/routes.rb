Rails.application.routes.draw do
  root to: redirect('/login')
  get '/dashboard', to: 'homes#welcome'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/logout', to: 'sessions#destroy'
  get '/authenticate', to: 'sessions#authenticate'
  resources :users
  resources :brands
  resources :categories
  resources :issues
  resources :items
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
