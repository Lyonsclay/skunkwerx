Skunkwerx::Application.routes.draw do

  
  get 'malone_tunings/index_deploy'

  resources :line_items do
    collection do
      post :remove_multiple
    end
  end

  resources :carts

  resources :orders, only: [:new, :create]

  # get "products/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'admin/login', to: 'admin/sessions#new', as: :login

  get 'admin/logout', to: 'admin/sessions#delete', as: :logout

  get 'admin', to: 'admin#index', via: 'get'

  namespace :admin do
    resources :sessions, only: [:new, :create, :destroy]
    resources :password_resets, except: [:index, :destroy]
    resources :products, only: [:index, :edit, :update]
    resources :freshbooks, only: [:index]
    resources :malone_tunings, except: [:show, :destroy]
    resources :malone_tuning_builders, only: [:create]
    resources :options, only: [:new, :create]
    post 'freshbooks/items_sync', to: 'freshbooks#items_sync', as: :items_sync
    post 'freshbooks/webhook_create', to: 'freshbooks#webhook_create', as: :webhook_create
    post 'freshbooks/webhooks_delete', to: 'freshbooks#webhooks_delete', as: :webhooks_delete
    post 'freshbooks/tunes_create', to: 'freshbooks#tunes_create', as: :tunes_create
  end

  get 'malone_tuning_builders_vehicles', to: 'admin/malone_tuning_builders#vehicle_index'

  get 'malone_tuning_builders_tunings', to: 'admin/malone_tuning_builders#tunings_index'

  post 'webhooks', to: 'admin/freshbooks#webhooks', as: :webhooks

  resources :contact, only: [:index]

  get 'products/index'

  get 'page_under_construction', to: 'page_under_construction#index'

  get 'malone_tunings/index'

  match '*path', to: redirect('/admin'), via: :all
end
