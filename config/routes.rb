require 'sidekiq/web'

Rails.application.routes.draw do
  resources :quotes
  mount RedactorRails::Engine => '/redactor_rails'
  resources :articles do
    resources :comments
  end

  resources :index_reports

  get 'user_favor_comment/create'

  get 'user_favor_comment/destroy'

  get 'pages/:name', to: "pages#show"

  mount RuCaptcha::Engine => "/rucaptcha"

  authenticate :user, lambda { |u| u.is_admin? } do
    namespace :panel do
      resources :stats

      resources :episodes

      resources :categories do
        member do
          post :create_projects
        end

        collection do
          get :search
        end
      end
      resources :catalogs do
        collection do
          get :search
        end
      end
      resources :projects do
        collection do
          get :search
          get :magic_search
          post :search_result
        end
      end
    end
  end

  resources :episodes do
    collection do
      # get 'today-recommends', to: "episodes#today", as: :today
      get :today
    end
  end
  # resources :developers, only: [:show]
  resources :developers, path: "manager"

  resources :net_worths

  resources :user_recommend_projects, only: [:create, :destroy]
  resources :user_star_projects, only: [:create, :destroy]
  resources :comments

  authenticate :user, lambda { |u| u.is_admin? } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :projects, path: "fund" do
    member do
      get :popularity, to: "repos#popularity"

      get :star, to: "repos#star"
      get :recommend, to: "repos#recommend"
    end

    resource :recommend_project, only: [:new, :create] do
      member do
        post 'add_to_episode/:episode_id', action: :add, as: :add_to
        delete 'remove_from_episode/:episode_id', action: :remove, as: :remove_from
      end
    end

    post :star, to: "user_star_projects#create"
    post :recommend, to: "user_recommend_projects#create"

    delete :star, to: "user_star_projects#destroy"
    delete :recommend, to: "user_recommend_projects#destroy"

    collection do
      get :search, to: "project_search#index"
      get :ruby_gems, to: "project_search#index", type: 'gemspec', as: :search_gem
      get :php_packages, to: "project_search#index", type: 'package', as: :search_package
      get :swift_pods, to: "project_search#index", type: 'pod', as: :search_pod
    end

    resources :comments
  end


  get ':author/:name/star', to: "repos#star", as: :star_repo
  get ':author/:name/recommend', to: "repos#recommend", as: :recommend_repo
  get ':author/:name/popularity', to: "repos#popularity", as: :popularity_repo


  resources :catalogs, path: "company"
  resources :categories

  get 'home/index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'ruby-gems', to: "catalogs#rails", as: :rails
  get 'Ruby-Gems', to: "catalogs#rails"
  get 'gems', to: "catalogs#rails"
  get 'swift-pods', to: "catalogs#swift", as: :swift
  get 'Swift-Pods', to: "catalogs#swift"
  get 'pods', to: "catalogs#swift"
  get 'PHP-Packages', to: "catalogs#laravel", as: :laravel
  get 'packages', to: "catalogs#laravel"

  get 'account', to: "users#account"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
  :passwords => "users/passwords", :registrations => "users/registrations",
  :sessions => "users/sessions" }

  resources :users, path: "u" do
    # get :id
  end

  get 'projects/:code-:slug', to: "projects#repo", as: :repo

  get ':name', to: "developers#show", as: :show_developer
end
