Rails.application.routes.draw do
  resources :subscription_plans

  mount Payola::Engine => '/payola', as: :payola
  apipie

  resources :pre_defined_cards

  resources :reviews

  resources :rewards

  resources :reminders

  resources :scorecards

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}, :controllers => {:registrations => 'my_devise/registrations',
                                                                                                                :omniauth_callbacks => "omniauth_callbacks", :sessions => 'my_devise/sessions', :passwords => 'users/passwords', :invitations => 'my_devise/invitations'}
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  # Auto-created by Devise
  # get 'users/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'welcome/index'

  get 'superusers/index'

  resources :pros, only: [:index]

  resources :supporters, only: [:index] do
    post '/invite' => 'supporters#invite', :on => :collection
  end

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

  get "/update_capture" => 'capture#update_capture', as: 'update_capture'

  get "/app_constants" => 'application#app_constants', as: 'app_constants'

  resources :conversations, :path => 'cards_stack', only: [:index, :show, :destroy] do
    member do
      post :reply
      post :restore
      post :mark_as_read
    end
    collection do
      delete :empty_trash
    end
  end

  resources :messages, :path => 'cards', only: [:new, :create] do
    get "random_draw", :on => :collection
  end

  resources :users, :path => 'thrivers' do
    post "migrate_from_thrivetracker", :on => :collection
    post "request_password_reset_from_thrivetracker", :on => :collection
    resources :moods
    resources :sleeps
    resources :self_cares
    resources :journals
  end

  resources :connections, :controller => 'friendships', :except => [:show, :edit] do
    get "thrivers", :on => :collection
    get "supporters", :on => :collection
    get "patients", :on => :collection
    get "providers", :on => :collection
  end

  resources :devices

  resources :subscription_plans
  resources :subscriptions

  flipper_constraint = lambda { |request| request.remote_ip == '127.0.0.1' }
  constraints flipper_constraint do
    mount Flipper::UI.app($flipper) => '/flipper'
  end

  require 'api_constraints'

  # Api definition
  namespace :api, defaults: {format: :json} do #, constraints: { subdomain: 'api' }, path: '/'  do
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
