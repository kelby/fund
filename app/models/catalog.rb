# == Schema Information
#
# Table name: catalogs
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  slug             :string(255)
#  type             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  categories_count :integer          default(0)
#  sketch           :string(255)
#

class Catalog < ApplicationRecord
  # Validates
  validates_uniqueness_of :name, scope: :type

  validates_presence_of :name
  validates_presence_of :type
  # END


  # Associations
  has_many :categories
  # END


  # Callbacks
  before_create :set_slug
  # END


  # Constants
  TOP_SINGULAR = {'gemspec' => "Ruby Gem", 'package' => "PHP Pacakge", 'pod' => "Swift Pod"}
  TOP_PLURAL = {'gemspec' => "Ruby Gems", 'package' => "PHP Pacakges", 'pod' => "Swift Pods"}
  # END


  # Rails class methods
  enum status: { online: 0, offline: 11 }
  # END


  def self.no_online_categories_so_offline
    Catalog.online.includes(:categories).map{|c| c.offline! if c.categories.all?{|x| x.offline? }}
  end

  def self.has_online_categories_so_online
    Catalog.offline.includes(:categories).map{|c| c.online! if c.categories.any?{|x| x.online? }}
  end

  def self.set_rails_catalog
    ["Active Record Plugins",
    "Background Processing",
    "Code Quality",
    "Communication",
    "Content Management & Blogging",
    "CSS",
    "Data Persistence",
    "Developer Tools",
    "Documentation Tools",
    "Documents & Reports",
    "E-Commerce and Payments",
    "Fun",
    "Graphics",
    "HTML & Markup",
    "JavaScript",
    "Maintenance & Monitoring",
    "Package & Dependency Management",
    "Provision, Deploy & Host",
    "Rails Plugins",
    "Security",
    "Testing",
    "Time & Space",
    "Web Apps, Services & Interaction"].each do |category|
      RailsCatalog.create(name: category, slug: Pinyin.t(category, splitter: '_'))
    end
  end

  def self.set_swift_catalog
    ["开源 App(OpenSourcesoftware)",
    "JSON解析",
    "图表(Chart)",
    "其他(other)",
    "引导页 (Intro&Guide View)",
    "网络（Network）",
    "动画(Animation)",
    "响应式编程(Reactive programming)",
    "图片处理",
    "数据库(Database)",
    "日志(log)"].each do |category|
      SwiftCatalog.create(name: category, slug: Pinyin.t(category, splitter: '_'))
    end
  end

  def self.set_laravel_catalog
    ["image",
    "laravel-debugbar",
    "laravel-ide-helper",
    "excel",
    "aws-sdk-php-laravel",
    "agent",
    "bugsnag-laravel",
    "entrust",
    "laravel-cors",
    "laravel-dompdf",
    "ardent",
    "jwt-auth",
    "oauth2-server-laravel",
    "slack",
    "mongodb",
    "api",
    "clockwork",
    "underscore-php",
    "generators",
    "eloquent-sluggable",
    "testdummy",
    "laravel-breadcrumbs",
    "utilities",
    "sitemap",
    "laravel-datatables-oracle",
    "laravel-uuid",
    "twigbridge",
    "imagecache",
    "dispatcher",
    "date",
    "laravel-log-viewer",
    "baum",
    "rocketeer",
    "former",
    "laravel-snappy",
    "twitter",
    "testbench",
    "campbell/flysystem",
    "purifier",
    "presenter",
    "revisionable",
    "laravel-localization",
    "factory-muffin",
    "presenter",
    "laravel-newrelic",
    "migrations-generator",
    "recaptcha",
    "validating",
    "laravel-translatable",
    "behat-laravel-extension",
    "rollbar",
    "geoip",
    "laravel-push-notification",
    "zipper",
    "simple-qrcode",
    "campbell/markdown",
    "twilio",
    "laravel-phone",
    "iseed",
    "laravel-facebook-sdk",
    "hashids",
    "laravel-backup",
    "laravel-auto-presenter",
    "campbell/throttle",
    "administrator",
    "laravel-stapler",
    "laravel-countries",
    "l5-repository",
    "google2fa",
    "browser-detect",
    "campbell/htmlmin",
    "geocoder-laravel",
    "notification",
    "integrated",
    "envoy",
    "uniquewith-validator",
    "campbell/exceptions",
    "laravel-gravatar",
    "captcha",
    "feed",
    "image-validator",
    "annotations",
    "shoppingcart",
    "laravel-soap",
    "swaggervel",
    "laravel-translation-manager",
    "bootstrapper",
    "laravel-formatter",
    "laravel-mail-css-inliner",
    "searchable",
    "phpspec-laravel",
    "rememberable",
    "laravel-tagging",
    "remote",
    "lavacharts",
    "ftp",
    "cron",
    "laroute",
    "laravel-analytics",
    "active"].each do |category|
      LaravelCatalog.create(name: category, slug: Pinyin.t(category, splitter: '_'))
    end
  end


  def human_supercatalog_name
    case self.type
    when "RailsCatalog"
      TOP_PLURAL['gemspec']
    when "LaravelCatalog"
      TOP_PLURAL['package']
    when "SwiftCatalog"
      TOP_PLURAL['pod']
    else
      "未知"
    end
  end

  def project_identity
    case self.type
    when "SwiftCatalog"
      'pod'
    when "RailsCatalog"
      'gemspec'
    when "LaravelCatalog"
      'package'
    else
      nil
    end
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '_')
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end

  def full_name
    "#{self.type} - #{self.name}"
  end
end
