Rails.application.routes.draw do
  root 'search#new'

  namespace :api do
    get '/autocomplete/members', to: 'autocomplete#members', as: 'autocomplete_members'
  end

  concern :taggable do
    resources :tags, only: [:create]
  end

  resources :search, only: [:new]
  get '/search', to: 'search#show', as: 'search'

  get '/profile', to: 'users/profile#edit', as: 'profile'
  patch '/profile', to: 'users/profile#update', as: 'update_profile'
  get '/profile/password', to: 'users/passwords#edit', as: 'password'
  patch '/profile/password', to: 'users/passwords#update', as: 'update_password'

  resources :resources, model_name: 'Resource', concerns: :taggable, only: [:show, :new, :create]

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
