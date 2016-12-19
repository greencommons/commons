Rails.application.routes.draw do
  root 'search#new'

  namespace :api do
    get '/autocomplete/members', to: 'autocomplete#members', as: 'autocomplete_members'
  end

  resources :search, only: [:new]
  resources :groups do
    resources :members, only: [:index, :create, :destroy] do
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
