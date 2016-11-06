Rails.application.routes.draw do
  devise_for :users
  resources :projects do
    member do
      get :popularity
    end
  end

  resources :catalogs
  resources :categories

  get 'home/index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'rails', to: "catalogs#rails"
  get 'swift', to: "catalogs#swift"
  get 'laravel', to: "catalogs#laravel"
end
