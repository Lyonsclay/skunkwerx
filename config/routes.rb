Skunkwerx::Application.routes.draw do

  resources :line_items do
    collection do
      post :remove_multiple
    end
  end

  resources :carts

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
    resources :malone_tunes
    post 'freshbooks/items_sync', to: 'freshbooks#items_sync', as: :items_sync
    post 'freshbooks/webhook_create', to: 'freshbooks#webhook_create', as: :webhook_create
    post 'freshbooks/webhooks_delete', to: 'freshbooks#webhooks_delete', as: :webhooks_delete
    post 'freshbooks/tunes_create', to: 'freshbooks#tunes_create', as: :tunes_create
  end

  get 'malone_tuning_index', to: 'admin/malone_tunes#malone_tuning_index'

  post 'webhooks', to: 'admin/freshbooks#webhooks', as: :webhooks

  resources :contact, only: [:index]

  get 'products/index'

  get 'page_under_construction', to: 'page_under_construction#index'

  get 'malone_tunes/index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
