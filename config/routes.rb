Rails.application.routes.draw do
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

  get 'account', to: "users#account"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users do
  end
end
