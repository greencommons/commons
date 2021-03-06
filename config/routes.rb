Rails.application.routes.draw do
  default_url_options Rails.application.config.action_mailer.default_url_options

  root 'static_pages#home'
  get '/privacypolicy', to: 'static_pages#policy', as: :policy
  get '/about', to: 'static_pages#about', as: :about

  # External API routes
  namespace :api do
    namespace :v1 do
      get '/search', to: 'search#show', as: 'search'
      resources :users, only: %i(create update)
      resources :resources, only: %i(show create update)
      resources :networks, only: %i(index show create update) do
        namespace :relationships do
          resources :users, only: %i(index) do
            collection do
              patch '/', action: 'update'
              post '/', action: 'create'
              delete '/', action: 'destroy'
            end
          end
        end
      end
      resources :lists, only: %i(show create) do
        namespace :relationships do
          resources :items, only: %i(index) do
            collection do
              patch '/', action: 'update'
              post '/', action: 'create'
              delete '/', action: 'destroy'
            end
          end
        end
      end
    end
  end

  # Internal API routes
  concern :taggable do
    resources :tags, only: [:create]
  end
  get '/autocomplete/members', to: 'autocomplete#members', as: 'autocomplete_members'
  get '/autocomplete/lists/:current_resource', to: 'autocomplete#lists', as: 'autocomplete_lists'
  get '/autocomplete/lists_owners', to: 'autocomplete#list_owners', as: 'autocomplete_list_owners'

  # User-facing routes
  resources :search, only: [:new]
  get '/search', to: 'search#show', as: 'search'

  get '/profile', to: 'users/profile#edit', as: 'profile'
  patch '/profile', to: 'users/profile#update', as: 'update_profile'

  resources :users, only: [] do
    resources :api_keys
  end

  resources :list_items, only: [:create, :destroy]

  resources :resources, model_name: 'Resource', concerns: :taggable
  resources :lists, model_name: 'List', concerns: :taggable

  resources :networks, model_name: 'Network', concerns: :taggable do
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

  resource :s3_signature, only: [:show]

  devise_for :users

  # TODO: replace this with a check for admin user
  if Rails.env.development? || ENV['ENABLE_SIDEKIQ_ADMIN']
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
