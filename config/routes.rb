Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'static#index'
  get 'about' => 'static#about', as: :about

  resources :stories, only: [:index, :show] do
    collection do
      get 'page/:page' => 'stories#index', as: :index_page
    end
    member do
      get :comments
    end
  end

  resources :challenges, only: [:index, :show] do
    collection do
      get 'page/:page' => 'challenges#index', as: :index_page
    end
  end

  resources :authors, only: [:index, :show] do
    collection do
      get 'page/:page' => 'authors#index', as: :index_page
    end
  end

  resources :blog, only: [:index, :show] do
    collection do
      get 'page/:page' => 'blog#index', as: :index_page
    end
  end

  resources :tags, only: [:index, :show] do
    member do
      get ':id/page/:page' => 'tags#show', as: :tag_page
    end
  end

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
