Rails.application.routes.draw do
  
  # Routes for main resources
  resources :items
  resources :purchases
  resources :item_prices
  resources :users
  resources :schools
  resources :sessions

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login
  
  # Cart stuff
  get 'cart' => 'home#cart', as: :cart
  post "items/:id/add_to_cart" => "items#add_to_cart", as: :add_to_cart
  post "items/:id/remove_from_cart" => "items#remove_from_cart", as: :remove_from_cart

  # Set the root url
  root :to => 'home#home'  

  get '*a', to: 'errors#routing'

end
