Rails.application.routes.draw do
  default_url_options Rails.application.config.action_mailer.default_url_options

  root 'search#new'

  # External API routes
  namespace :api do
    namespace :v1 do
      get '/search', to: 'search#show', as: 'search'
    end
  end

  # Internal API routes
  concern :taggable do
    resources :tags, only: [:create]
  end
  get '/autocomplete/members', to: 'autocomplete#members', as: 'autocomplete_members'

  # User-facing routes
  resources :search, only: [:new]
  get '/search', to: 'search#show', as: 'search'

  get '/profile', to: 'users/profile#edit', as: 'profile'
  patch '/profile', to: 'users/profile#update', as: 'update_profile'
  get '/profile/password', to: 'users/passwords#edit', as: 'password'
  patch '/profile/password', to: 'users/passwords#update', as: 'update_password'

  resources :resources, model_name: 'Resource', concerns: :taggable

  resources :groups, model_name: 'Group', concerns: :taggable do
    resources :members, only: [:index, :create, :destroy] do
      collection do
        post :join
        delete :leave
      end
      member do
        post :make_admin
        post :remove_admin
      end
    end
  end

  devise_for :users

  # TODO: replace this with a check for admin user
  if Rails.env.development? || ENV['ENABLE_SIDEKIQ_ADMIN']
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
