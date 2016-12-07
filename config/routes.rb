require 'sidekiq/web'

Rails.application.routes.draw do
  # resources :developers, only: [:show]
  resources :developers

  resources :user_recommend_projects, only: [:create, :destroy]
  resources :user_star_projects, only: [:create, :destroy]
  resources :comments

  authenticate :user, lambda { |u| u.is_admin? } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :projects do
    member do
      get :popularity

      get :star
      get :recommend
    end

    post :star, to: "user_star_projects#create"
    post :recommend, to: "user_recommend_projects#create"

    delete :star, to: "user_star_projects#destroy"
    delete :recommend, to: "user_recommend_projects#destroy"

    collection do
      get :search, to: "project_search#index"
      get :search_gem, to: "project_search#index", type: 'gem'
      get :search_package, to: "project_search#index", type: 'package'
      get :search_pod, to: "project_search#index", type: 'pod'
    end

    resources :comments
  end

  resources :catalogs
  resources :categories

  get 'home/index'
  get ':author/:name', to: "projects#repo", as: :repo

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'rails', to: "catalogs#rails"
  get 'swift', to: "catalogs#swift"
  get 'laravel', to: "catalogs#laravel"

  get 'account', to: "users#account"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users do
  end

  get ':name', to: "developers#show", as: :show_developer
end
