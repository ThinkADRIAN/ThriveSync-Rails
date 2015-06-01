Rails.application.routes.draw do
  
  resources :scorecards

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}, :controllers => {:registrations => 'my_devise/registrations',
    :omniauth_callbacks => "omniauth_callbacks", :sessions => 'users/sessions', :passwords => 'users/passwords'}
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  # Auto-created by Devise
  # get 'users/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'welcome/index'

  get 'superusers/index'

  get 'pros/index'

  match 'moods/cancel' => 'moods#cancel', :via => :get

  match 'sleeps/cancel' => 'sleeps#cancel', :via => :get

  match 'self_cares/cancel' => 'self_cares#cancel', :via => :get

  match 'journals/cancel' => 'journals#cancel', :via => :get

  resources :moods do
    get "delete"
  end

  resources :sleeps do
    get "delete"
  end

  resources :self_cares do
    get "delete"
  end

  resources :journals do
    get "delete"
  end

  resources :users, :path => 'thrivers' do
    resources :moods
    resources :sleeps
    resources :self_cares
    resources :journals
  end

  resources :connections, :controller => 'friendships', :except => [:show, :edit] do
    get "requests", :on => :collection
    get "invites", :on => :collection
  end

  require 'api_constraints'

  # Api definition
  namespace :api, defaults: { format: :json } do#, constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_scope :user do
        post '/registrations' => 'registrations#create'
        put '/registrations' => 'registrations#update'
        post '/sessions' => 'sessions#create'
        delete '/sessions' => 'sessions#destroy'
        post '/passwords' => 'passwords#create'
      end

      resources :sessions, :only => [:create, :destroy]
      resources :registrations, :only => [:create, :update, :destroy]
      resources :passwords, :only => [:create, :update]
    end
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
