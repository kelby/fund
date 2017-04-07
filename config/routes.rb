require 'sidekiq/web'

Rails.application.routes.draw do
  # get 'quickrank_performances/index'

  # get 'quickrank_portfolios/index'

  # get 'quickrank_snapshots/index'

  resources :quickrank do
    collection do
      # get ":date_history", to: "quickrank#date_history", as: :date_history

      get :performance, to: "quickrank_performances#index"
      get :portfolio, to: "quickrank_portfolios#index"
      get :snapshot, to: "quickrank_snapshots#index"
      get :history, to: "fund_rankings#index"

      get :search
      post :search
    end
  end

  get "quickrank/history/search", to: "fund_rankings#search"

  resources :tags, path: 'tag', only: [:index, :show]

  resources :fund_yields
  resources :task_logs
  resources :fund_rankings
  resources :stocks
  resources :quotes


  resources :fund_fen_hongs do
    collection do
      get :list
    end
  end

  resources :fund_chai_fens


  mount RedactorRails::Engine => '/redactor_rails'

  resources :articles do
    resources :comments

    resources :agreement_articles, only: [:create, :destroy]
  end

  resources :index_reports, path: 'index_report'

  # resources :index_catalogs
  # resources :index_categories

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

      get :calculus, to: "project_arithmetic#calculus"

      get :managers

      get :distribute
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

  resources :developer_projects, only: [:destroy]

  get ':author/:name/star', to: "repos#star", as: :star_repo
  get ':author/:name/recommend', to: "repos#recommend", as: :recommend_repo
  get ':author/:name/popularity', to: "repos#popularity", as: :popularity_repo


  resources :catalogs, path: "company" do
    resources :catalog_developers, path: 'managers', only: [:index]
  end
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

  # get ':name', to: "developers#show", as: :show_developer
end
