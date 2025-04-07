Rails.application.routes.draw do
  devise_for :admins
  ActiveAdmin.routes(self)

  # ✅ Main store route
  get "store", to: "store#index"
  get "/store/category/:id", to: "store#category", as: "store_category"
  get 'store/products/:id', to: 'store#show', as: 'store_product'
  get 'store/new', to: 'store#new_products', as: :store_new_products
  get 'store/sale', to: 'store#on_sale', as: :store_on_sale
  # ✅ Optional: set as homepage
  root to: "store#index"
end
