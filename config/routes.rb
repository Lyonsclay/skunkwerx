Skunkwerx::Application.routes.draw do

  
  get 'malone_tunes/index_deploy'

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
    resources :malone_tunes, except: [:show, :destroy]
    resources :malone_tunings, only: [:create]
    resources :options, only: [:new, :create]
    post 'freshbooks/items_sync', to: 'freshbooks#items_sync', as: :items_sync
    post 'freshbooks/webhook_create', to: 'freshbooks#webhook_create', as: :webhook_create
    post 'freshbooks/webhooks_delete', to: 'freshbooks#webhooks_delete', as: :webhooks_delete
    post 'freshbooks/tunes_create', to: 'freshbooks#tunes_create', as: :tunes_create
  end

  get 'malone_tunings_vehicles', to: 'admin/malone_tunings#vehicle_index'

  post 'webhooks', to: 'admin/freshbooks#webhooks', as: :webhooks

  resources :contact, only: [:index]

  get 'products/index'

  get 'page_under_construction', to: 'page_under_construction#index'

  get 'malone_tunes/index'

  match '*path', to: redirect('/admin'), via: :all
end
