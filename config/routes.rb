Rails.application.routes.draw do
  resources :categories
  get 'home/index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'rails', to: "categories#rails"
  get 'swift', to: "categories#swift"
  get 'laravel', to: "categories#laravel"
end
