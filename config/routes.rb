Skunkwerx::Application.routes.draw do
  # get "products/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'admin/login', to: 'sessions#new', as: :login

  get 'admin/logout', to: 'sessions#delete', as: :logout

  get 'admin', to: 'admin#index', via: 'get'

  # get 'products/edit', to: 'products#edit', as: :edit_product

  namespace :admin do
    resources :products, only: [:index, :edit, :update]
    resources :freshbooks, only: [:index]
    post 'freshbooks/items_sync', to: 'freshbooks#items_sync', as: :items_sync
    post 'freshbooks/callback_item_create', to: 'freshbooks#callback_item_create', as: :callback_item_create
  end

  post 'callback_verify', to: 'admin/freshbooks#callback_verify', as: :callback_verify

  get 'malone_tunes/index'

  resources :sessions, only: [:new, :create, :destroy]

  resources :contact, only: [:index]

  get 'products/index'

  get 'page_under_construction', to: 'page_under_construction#index'

  resources :password_resets, except: [:index]

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
