Rails.application.routes.draw do
  root 'search#new'

  resources :search, only: [:new]

  devise_for :users

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
