Rails.application.routes.draw do
  
  devise_for :rails_users, :controllers => {:registrations => "my_devise/registrations"}
  match '/rails_users/:id/finish_signup' => 'rails_users#finish_signup', via: [:get, :patch], :as => :finish_signup

  # Auto-created by Devise
  # get 'rails_users/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'welcome/index'

  get 'superusers/index'

  get 'pros/index'

  resources :moods do
  end

  resources :sleeps do
  end

  resources :self_cares do
  end

  resources :journals do
  end

  resources :rails_users do
    resources :moods
    resources :sleeps
    resources :self_cares
    resources :journals
  end

  resources :connections, :controller => 'friendships', :except => [:show, :edit] do
    get "requests", :on => :collection
    get "invites", :on => :collection
  end

  devise_scope :rails_users do
    match "/rails_users/auth/:provider",
      constraints: { provider: /google|facebook/ },
      to: "rails_users/omniauth_callbacks#passthru",
      as: :user_omniauth_authorize,
      via: [:get, :post]
    match "/rails_users/auth/:action/callback",
      constraints: { action: /google|facebook/ },
      to: "rails_users/omniauth_callbacks",
      as: :user_omniauth_callback,
      via: [:get, :post]
  end

  #map.resources :relationships

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
