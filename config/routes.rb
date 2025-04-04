Rails.application.routes.draw do
  devise_for :admins
  ActiveAdmin.routes(self)

  # ✅ Main store route
  get "store", to: "store#index"
  get "/store/category/:id", to: "store#category", as: "store_category"

  # ✅ Optional: set as homepage
  root to: "store#index"
end
