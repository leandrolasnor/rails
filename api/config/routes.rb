# frozen_string_literal: true

require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'
Rails.application.routes.draw do
  namespace :moat do
    resources :artists, only: [:index]
    resources :albums, id: /[0-9\-_]+/, only: [:create, :update, :destroy, :show]
    namespace :albums do
      get '/search(/:query)', query: /[a-zA-Z0-9\-_20%]+/, action: :search, as: :search
    end
  end

  namespace :latech do
    namespace :addreses do
      get 'search(/:query)', query: /[a-zA-Z0-9\-_20%]+/, action: :search, as: :search
      get 'capture/:zip', zip: /([0-9])\d{7}/, action: :capture, as: :capture
    end
  end

  namespace :estimates do
    post 'quantity_of_can_of_paint', action: :quantity_of_can_of_paint, as: :quantity_of_can_of_paint
  end

  mount Sidekiq::Web => '/sidekiq'
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { sessions: 'overrides/sessions', registrations: 'overrides/registrations' }

  root to: 'api#health', via: :all
  match '*path' => 'api#not_found', via: :all
end
