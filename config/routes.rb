Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
