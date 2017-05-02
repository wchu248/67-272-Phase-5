Rails.application.routes.draw do
  
  # Routes for main resources
  resources :items
  resources :purchases
  resources :item_prices
  resources :users
  resources :schools
  resources :orders
  resources :sessions

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # shipper ajax
  get "home/toggle/:id" => "home#toggle", as: :toggle

  # cart stuff
  get "view_cart" => "home#view_cart", as: :view_cart
  get "item/add_to_cart/:id" => "item#add_to_cart", as: :add_to_cart

  # Set the root url
  root :to => 'home#home'  

end
