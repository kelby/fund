source 'https://gems.ruby-china.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2' #, '>= 5.0.0.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.8'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano3-puma'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-secrets-yml', '~> 1.0.0'
  gem 'capistrano-sidekiq'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bootstrap-sass', '~> 3.3.6'

gem 'chinese_pinyin'

gem 'devise'

gem "font-awesome-rails"

gem 'omniauth-github'
gem "omniauth-google-oauth2"

gem 'cancancan', '~> 1.10'

gem 'config'

gem 'annotate'


gem 'rails_admin', '~> 1.0'

gem 'redcarpet'

gem 'sidekiq'

# https://github.com/redis/redis-rb
gem 'redis', '~>3.2'
# hiredis-rb is a binding to the official hiredis client library.
gem "hiredis", "~> 0.4.5"
# options: 配置里有 namespace 或 Redis::Namespace
gem 'redis-namespace'

gem 'dalli'

# gem 'sinatra', require: false
# fixbug: cannot load such file -- rack/showexceptions
gem 'sinatra', github: 'sinatra/sinatra', branch: 'master'

gem 'kaminari'

gem 'meta-tags'

gem 'whenever', :require => false

gem 'nokogiri'

gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'exception_notification'

gem 'carrierwave', '>= 1.0.0.rc', '< 2.0'
gem "mini_magick"

gem 'counter_culture', '~> 1.0'

gem "select2-rails"

gem 'browser'

gem "paranoia", "~> 2.2"

gem "sitemap_generator"


gem 'anemone'

gem 'rucaptcha'

# crawl
gem 'watir'
# gem 'watir-webdriver'
gem 'headless'

# POST data to server from my local server.
gem 'rest-client'

# The auto_link function from Rails
# 处理 article 内容，用不上了（影响了样式）
# gem "rails_autolink"

# integrates the Redactor editor with the Rails 3.2 asset pipeline.
# 本网站只有一个编辑器。但代码却由两部分构成，一个负责前端，一个负责涉及到的后端（文件上传）
# 后者由此 gem 实现。协作的时候有问题，所以需要一点定制。不要其前端、配置其保存路径。
gem 'redactor-rails', :github => 'shixiancom/redactor-rails'

gem 'sanitize'

gem 'acts-as-taggable-on', '~> 4.0'

gem 'social-share-button'

gem 'rails-i18n'#, '~> 5.0.0' # For 5.0.x

# a fast, pure Ruby Markdown superset converter
gem 'kramdown'
# Note: 这两个解析器二选一，目前暂时使用 redcarpet
# The safe Markdown parser, reloaded.
gem 'redcarpet'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS)
gem 'rack-cors', :require => 'rack/cors'
