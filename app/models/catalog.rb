# == Schema Information
#
# Table name: catalogs
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  slug                    :string(255)
#  type                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  categories_count        :integer          default(0)
#  sketch                  :string(255)
#  status                  :integer          default("online")
#  footnote                :text(65535)
#  online_categories_count :integer          default(0)
#  initial                 :integer          default("initial_unknow")
#  short_name              :string(255)
#  founder                 :string(255)
#  set_up_at               :date
#  scale                   :string(255)
#  scale_record_at         :date
#  code                    :string(255)
#  raw_show_html           :text(65535)
#  projects_count          :integer          default(0), not null
#  sina_code               :string(255)
#  cover                   :string(255)
#  description             :text(65535)
#

# initial 拼音首字母
# short_name 简称
# founder 总经理
# set_up_at 成立时间
# scale
# scale_record_at
class Catalog < ApplicationRecord
  # Validates
  validates_uniqueness_of :name #, scope: :type
  validates_uniqueness_of :short_name, allow_blank: true

  validates_presence_of :name
  # validates_presence_of :code
  # validates_presence_of :type
  # END


  # Associations
  has_many :projects

  has_many :categories
  has_many :online_categories, -> { where(status: Category.statuses['online']) }, class_name: "Category"


  has_many :catalog_developers
  has_many :developers, through: :catalog_developers

  has_one :catalog_sina_info
  has_one :catalog_eastmoney_info
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
  enum initial: { :initial_unknow => 0,
    a: 1, b: 2, c: 3, d: 4, e: 5,
    f: 6, g: 7, h: 8, i: 9, j: 10,
    k: 11, l: 12, m: 13, n: 14, o: 15,
    p: 16, q: 17, r: 18, s: 19, t: 20,
    u: 21, v: 22, w: 23, x: 24, y: 25,
    z: 26 }

  scope :has_projects, -> { where("projects_count > ?", 0) }
  # END


  # Plugins
  mount_uploader :cover, AvatarUploader
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
      # RailsCatalog.create(name: category, slug: Pinyin.t(category, splitter: '_'))
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
      # SwiftCatalog.create(name: category, slug: Pinyin.t(category, splitter: '_'))
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
      # LaravelCatalog.create(name: category, slug: Pinyin.t(category, splitter: '_'))
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

  def human_type
    # case self.type
    # when "RailsCatalog"
    #   TOP_SINGULAR['gemspec']
    # when "LaravelCatalog"
    #   TOP_SINGULAR['package']
    # when "SwiftCatalog"
    #   TOP_SINGULAR['pod']
    # else
      "未知"
    # end
  end

  def project_identity
    # case self.type
    # when "SwiftCatalog"
    #   'pod'
    # when "RailsCatalog"
    #   'gemspec'
    # when "LaravelCatalog"
    #   'package'
    # else
      nil
    # end
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '-')
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end

  def full_name
    "#{self.type} - #{self.name}"
  end

  def set_initial
    self.initial = Pinyin.t(self.short_name).first
  end
end
