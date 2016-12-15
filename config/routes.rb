require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.is_admin? } do
    namespace :panel do
      resources :categories do
        collection do
          get :search
        end
      end
      resources :catalogs do
        collection do
          get :search
        end
      end
      resources :projects
    end
  end

  resources :episodes
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
      get :ruby_gems, to: "project_search#index", type: 'gem', as: :search_gem
      get :php_packages, to: "project_search#index", type: 'package', as: :search_package
      get :swift_pods, to: "project_search#index", type: 'pod', as: :search_pod
    end

    resources :comments
  end

  resources :catalogs
  resources :categories

  get 'home/index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'Ruby-Gems', to: "catalogs#rails", as: :rails
  get 'gems', to: "catalogs#rails"
  get 'Swift-Pods', to: "catalogs#swift", as: :swift
  get 'pods', to: "catalogs#swift"
  get 'PHP-Packages', to: "catalogs#laravel", as: :laravel
  get 'packages', to: "catalogs#laravel"

  get 'account', to: "users#account"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, path: "u" do
    # get :id
  end

  get ':author/:name', to: "projects#repo", as: :repo

  get ':name', to: "developers#show", as: :show_developer
end
