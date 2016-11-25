Rails.application.routes.draw do
  resources :comments

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :projects do
    member do
      get :popularity
    end

    collection do
      get :search
      get :search_gem, to: "projects#search", type: 'gem'
      get :search_package, to: "projects#search", type: 'package'
      get :search_pod, to: "projects#search", type: 'pod'
    end

    resources :comments
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
