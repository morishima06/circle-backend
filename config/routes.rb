# frozen_string_literal: true

Rails.application.routes.draw do
  # Customer authentication (Devise)
  devise_for :customers,
             path: 'api/v1',
             path_names: {
               sign_in: 'customers/login',
               sign_out: 'customers/logout'
             },
             controllers: {
               sessions: 'api/v1/customers/auth/sessions',
               omniauth_callbacks: 'api/v1/customers/auth/omniauth_callbacks'
             }

  # Admin authentication (Devise)
  devise_for :admin,
             path: 'api/v1/admin',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
               sessions: 'api/v1/admin/sessions'
             }

  # API v1
  namespace :api do
    namespace :v1 do
      # Home
      root 'homes#index'

      get '/homes', to: 'homes#get_test'
      post '/homes', to: 'homes#post_test'

      # search
      get '/search', to: 'search#index'

      # Products / Collections
      get '/designers', to: 'designers#index'
      get '/designers/suggestions', to: 'designers#suggestions'

      get '/:gender/p/:designer/:style_code',
          to: 'products#show',
          constraints: { gender: /men|women/ }

      get '/:gender(/*path)',
          to: 'collections#index',
          constraints: { gender: /men|women/ }

      # Cart
      get '/cart', to: 'carts#show'
      get '/cart_item_count', to: 'carts#cart_item_count'

      resources :cart_items,
                only: %i[create destroy update],
                param: :sku_id

      # Orders
      resources :orders,
                only: %i[create],
                path: 'orders'

      get '/order', to: 'orders#show'
      patch '/order', to: 'orders#update'

      get '/orders/complete', to: 'orders#complete'

      post '/orders/:id/checkout_complete_token',
           to: 'orders#create_checkout_complete_token'

      # Guest order
      get '/guest/orders/:number', to: 'guest/orders#show'

      # Checkout
      post '/checkout/confirm', to: 'checkout#confirm'

      post '/checkout/complete_checkout',
           to: 'payments#complete_checkout'

      post '/checkout/create_intent',
           to: 'payments#create_stripe_payment_intent'

      # Payments
      resources :payments,
                only: %i[create update],
                path: 'payments'

      post '/payments/sync', to: 'payments#sync'
      post '/payments/reserve_stock', to: 'payments#reserve_stock'
      get '/payments/stripe_key', to: 'payments#stripe_key'

      # Customer authentication
      devise_scope :customer do
        get '/current_customer',
            to: 'customers/auth/sessions#current'
      end

      post '/customers/register',
           to: 'customers/auth/registrations#create'

      get '/customers/verify_login_token',
          to: 'customers/auth/sessions#verify_login_token'

      # Two-factor authentication
      get '/customers/two_factor',
          to: 'customers/auth/two_factors#edit'

      patch '/customers/two_factor/verify_otp',
            to: 'customers/auth/two_factors#verify_otp'

      # Password reset
      post '/customers/password_resets',
           to: 'customers/auth/password_resets#create'

      get '/customers/password_resets/:token/edit',
          to: 'customers/auth/password_resets#edit'

      patch '/customers/password_resets',
            to: 'customers/auth/password_resets#update'

      # Customer account
      scope path: 'customers' do
        resource :account,
                 only: %i[show update],
                 controller: 'customers/account',
                 path: 'account'

        resource :profile,
                 only: [:update],
                 controller: 'customers/account',
                 path: 'profile'

        # Addresses
        resources :addresses,
                  controller: 'customers/addresses',
                  only: %i[index show create edit update destroy]

        # Customer orders
        resources :orders,
                  param: :number,
                  controller: 'customers/orders',
                  only: %i[index show]

        # Favorites
        resources :favorites,
                  controller: 'customers/favorites',
                  only: %i[index create destroy],
                  param: :product_id

        get '/favorites/check',
            to: 'customers/favorites#check'
      end

      # Favorite IDs
      get '/favorites/ids', to: 'favorites#ids'

      # Webhooks
      post '/webhooks', to: 'webhooks#create'

      # OAuth
      get '/auth/failure', to: 'omniauth#failure'

      # Admin
      namespace :admin do
        # Dashboard
        get '/dashboard', to: 'dashboard#show'
        get '/dashboard/chart', to: 'dashboard#chart'

        # Colors
        resources :colors, only: [:index]

        # Categories
        resources :categories, only: [] do
          collection do
            get :tree
          end

          resources :sizes,
                    only: [:index],
                    controller: 'sizes'
        end

        # Designers
        resources :designers, only: [:index] do
          collection do
            get :search
          end
        end

        # Product images
        resources :product_images, only: [:create]

        # Products
        resources :products,
                  only: %i[index show create] do
          member do
            patch :edit, action: :update
          end
        end

        # Orders
        resources :orders, only: %i[index show] do
          member do
            patch :ship
          end

          collection do
            get :counts
          end
        end

        # Customers
        resources :customers, only: [:index]

        # CSV
        post '/csv/orders', to: 'csv#export_orders'
        post '/csv/customers', to: 'csv#export_customers'
        # Current admin
        devise_scope :admin do
          get '/current_admin',
              to: 'sessions#current'
        end
      end
    end
  end
end
