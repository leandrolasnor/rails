require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount_devise_token_auth_for 'User', at: 'auth', controllers:{sessions: 'overrides/sessions', registrations: 'overrides/registrations'}

  root to: "api#health", via: :all
  
  get  '/albums/search/:query', query: /[a-zA-Z0-9\-_]+/, to: 'albums#search'
  get  '/albums/search', to: 'albums#search'
  resources :albums, id: /[0-9\-_]+/, only: [:show, :update, :destroy, :create]

  get '/artists', to: 'artists#list'
  match "*path" => "api#not_found", via: :all
end
