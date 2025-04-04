Rails.application.routes.draw do
  devise_for :admins
  
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  root "admin/dashboard#index" # temporary for quick testing
end
