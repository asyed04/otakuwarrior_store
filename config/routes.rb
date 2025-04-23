Rails.application.routes.draw do
  devise_for :customers
  get 'pages/show'
  devise_for :admins
  ActiveAdmin.routes(self)

  # Storefront routes
  get "store", to: "store#index"
  get "/store/category/:id", to: "store#category", as: "store_category"
  get 'store/products/:id', to: 'store#show', as: 'store_product'
  get 'store/new', to: 'store#new_products', as: :store_new_products
  get 'store/sale', to: 'store#on_sale', as: :store_on_sale
  get 'store/search', to: 'store#search', as: :store_search

  # Cart routes
  post "add_to_cart/:id", to: "cart#add", as: "add_to_cart"
  patch "update_cart/:id", to: "cart#update", as: "update_cart"
  delete "remove_from_cart/:id", to: "cart#remove", as: "remove_from_cart"
  get "cart", to: "cart#show", as: "cart"

  # Checkout routes
  get "checkout", to: "checkout#new", as: "checkout"
  get "simple_checkout", to: "checkout#simple", as: "simple_checkout"
  post "checkout/confirm", to: "checkout#confirm", as: "checkout_confirm"
  post "checkout", to: "checkout#create", as: "checkout_create"
  post "checkout/payment", to: "checkout#payment", as: "checkout_payment"
  get "invoice/latest", to: "checkout#latest_invoice", as: "latest_invoice"
  get "invoice/:id", to: "checkout#invoice", as: "invoice"
  
  # Customer profile routes
  get "profile", to: "profile#show", as: "profile"
  get "profile/edit", to: "profile#edit", as: "edit_profile"
  patch "profile", to: "profile#update", as: "update_profile"
  get "profile/orders", to: "profile#orders", as: "profile_orders"
  get "profile/orders/:id", to: "profile#order", as: "profile_order"
  post "profile/orders/:id/pay", to: "profile#pay_order", as: "pay_profile_order"
  post "profile/orders/:id/cancel", to: "profile#cancel_order", as: "cancel_profile_order"

  # Homepage
  root to: "store#index"

  # Static Page routes
  get '/pages/:slug', to: 'pages#show', as: :static_page
  
  #stripe routes
  post "checkout/payment", to: "checkout#payment"
  
  # Test route for Stripe configuration (remove in production)
  get "stripe/test", to: "stripe_test#test"
end
