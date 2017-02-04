# == Schema Information
#
# Table name: projects
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :text(65535)
#  website         :string(255)
#  wiki            :string(255)
#  source_code     :string(255)
#  category_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  identity        :integer          default("unknow")
#  author          :text(65535)
#  status          :integer          default("pending")
#  popularity      :decimal(15, 2)
#  developer_id    :integer
#  today_recommend :boolean
#  recommend_at    :datetime
#  human_name      :string(255)
#  given_name      :string(255)
#  view_times      :integer          default(0)
#  code            :string(255)
#  catalog_id      :integer
#  mold            :string(255)
#  slug            :string(255)
#  set_up_at       :date
#  mother_son      :integer          default("mother_son_normal")
#  release_status  :integer          default("release_end")
#  comments_count  :integer          default(0)
#

require 'elasticsearch/model'

class Project < ApplicationRecord
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  include Searchable

  # Associations
  belongs_to :catalog, counter_cache: true

  belongs_to :category # , counter_cache: true
  counter_culture :category
  counter_culture :category, :column_name => proc {|model| model.online? ? 'online_projects_count' : nil }

  # belongs_to :developer

  has_one :github_info

  has_one :gem_info
  has_one :pod_info
  has_one :package_info

  has_one :fund_raise
  has_many :fund_jbgks

  has_many :comments, as: :commentable

  has_many :user_star_projects
  has_many :user_recommend_projects

  has_many :star_by_users, through: :user_star_projects, source: :user
  has_many :recommend_by_users, through: :user_recommend_projects, source: :user

  has_many :net_worths
  has_many :developer_projects
  has_many :developers, through: :developer_projects


  # 关系比较复杂时，先从简单的开始。所以，这是第二步
  has_many :son_project_associations, class_name: 'Kinsfolk', foreign_key: :mother_id
  # 关系比较复杂时，先从简单的开始。有了第二步，自然到这第三步
  has_many :son_projects, class_name: 'Project', through: :son_project_associations, foreign_key: :mother_id

  # 关系比较复杂时，先从简单的开始。所以，这是第二步
  has_one :mother_project_association, class_name: 'Kinsfolk', foreign_key: :son_id
  # 关系比较复杂时，先从简单的开始。有了第二步，自然到这第三步
  has_one :mother_project, class_name: 'Project', through: :mother_project_association, foreign_key: :son_id

  has_many :project_items
  # END


  # Rails class methods
  enum identity: {unknow: 0, gemspec: 2, package: 4, pod: 6}
  # 等待处理，下线，上线；Star 数目小于100; 长时间不更新、废弃；只是单纯的github项目、不是插件
  enum status: {pending: 0, offline: 4, online: 6, nightspot: 8,
    deprecated: 10, site_invalid: 12, not_want: 14}

  enum mother_son: { mother_son_normal: 0, mother: 2, son: 4 }

  # 已发行完毕，正常买卖、或暂停；正在发行；将要发行
  enum release_status: { release_end: 0, release_now: 2, release_will: 4 }

  scope :confirm_lineal, -> { where(mother_son: [Project.mother_sons['mother_son_normal'], Project.mother_sons['mother']]) }
  scope :nolimit, -> { unscope(:limit, :offset) }
  scope :show_status, -> { where(status: [Project.statuses['online'], Project.statuses['nightspot'], Project.statuses['deprecated']]) }

  # enum mold: {mold_unknow: 0, general: 2, cur: 4, fq: 6, mold_other: 8}
  # END


  # Validates
  # validates_presence_of :source_code
  # validates_presence_of :category_id

  validates_uniqueness_of :name, scope: :author, message: "该用户的项目已经存在，您不必重复添加"
  # END


  # Callbacks
  # after_commit :logic_set_gem_info, on: :create
  # after_commit :logic_set_pod_info, on: :create
  # after_commit :logic_set_package_info, on: :create

  # after_commit :set_github_info, on: :create

  # after_create :aysc_set_developer_info
  # after_commit :set_readme, on: :create

  # after_create :build_github_info

  # before_validation :set_github_identity

  before_create :set_slug

  after_update :detect_and_set_recommend_at
  after_update :detect_given_name_changed
  after_update :detect_set_category_online
  # END


  # Constants
  API_GITHUB = "https://api.github.com/"

  RAILS_BASE = {'watchers' => 2321, 'stars' => 33566, 'forks' => 13698, 'downloads' => 81138762}
  SWIFT_BASE = {'watchers' => 2406, 'stars' => 35406, 'forks' => 5135, 'downloads' => 81138762}
  LARAVEL_BASE = {'watchers' => 3522, 'stars' => 27582, 'forks' => 9131, 'downloads' => 3941137}
  # END

  def last_trade_net_worth
    self.net_worths.order(record_at: :desc).first
  end

  def last_trade_day
    self.last_trade_net_worth.record_at
  end

  # begin last week
  def last_week_trade_day
    self.last_trade_day.weeks_ago(1)
  end

  def last_week_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_week_trade_day).order(record_at: :desc).first
  end

  def last_week_ranking
    ((last_trade_net_worth.dwjz - last_week_trade_day_net_worth.dwjz) / last_week_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last week

  # begin last month
  def last_month_trade_day
    self.last_trade_day.months_ago(1)
  end

  def last_month_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_month_trade_day).order(record_at: :desc).first
  end

  def last_month_ranking
    ((last_trade_net_worth.dwjz - last_month_trade_day_net_worth.dwjz) / last_month_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last month

  # begin last three month
  def last_three_month_trade_day
    self.last_trade_day.months_ago(3)
  end

  def last_three_month_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_three_month_trade_day).order(record_at: :desc).first
  end

  def last_three_month_ranking
    ((last_trade_net_worth.dwjz - last_three_month_trade_day_net_worth.dwjz) / last_three_month_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last three month

  # begin last six month
  def last_six_month_trade_day
    self.last_trade_day.months_ago(6)
  end

  def last_six_month_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_six_month_trade_day).order(record_at: :desc).first
  end

  def last_six_month_ranking
    ((last_trade_net_worth.dwjz - last_six_month_trade_day_net_worth.dwjz) / last_six_month_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last six month

  def confirm_lineal?
    self.mother_son_normal? || self.mother?
  end

  def short_github_indentity
    "#{self.author}/#{self.name}"
  end

  def detect_set_category_online
    if (self.status_changed? && self.online?) && self.category.present?
      self.category.online!
    end
  end

  def detect_given_name_changed(force=true)
    if given_name_changed? && given_name.present?
      if force
        self.logic_set_info
      end
    end
  end

  def self.delay_set_popularity
    Project.pending.joins(:github_info).where(popularity: nil).map{|x| x.logic_set_popularity }
  end

  def logic_set_popularity
    case self.identity
    when 'gemspec'
      self.set_gem_popularity
    when 'package'
      self.set_package_popularity
    when 'pod'
      self.set_pod_popularity
    else
      # ...
    end
  end

  def self.set_gem_popularity
    self.gemspec.joins(:github_info, :gem_info).distinct.each do |project|
      if project.github_info.blank? || project.gem_info.blank?
        next
      end

      project.set_gem_popularity
      project.save!
    end
  end

  def set_gem_popularity
    # p self.id
    a = self.subscribers_count.to_f / Project::RAILS_BASE['stars']
    # p a
    b = self.watchers_count.to_f / Project::RAILS_BASE['watchers']
    # p b
    c = self.forks_count.to_f / Project::RAILS_BASE['forks']
    # p c

    e = (a + b + c) / 3
    # p e

    d = self.total_downloads.to_f / Project::RAILS_BASE['downloads']
    # p d

    self.popularity = ((e + d) / 2 * 100).round(4)

    if self.changed?
      self.save
    end
  end


  def self.set_package_popularity
    self.package.joins(:github_info, :package_info).distinct.each do |project|
      if project.github_info.blank? || project.package_info.blank?
        next
      end

      project.set_package_popularity
      project.save!
    end
  end

  def set_package_popularity
    # p self.id
    a = self.subscribers_count.to_f / Project::LARAVEL_BASE['stars']
    # p a
    b = self.watchers_count.to_f / Project::LARAVEL_BASE['watchers']
    # p b
    c = self.forks_count.to_f / Project::LARAVEL_BASE['forks']
    # p c

    e = (a + b + c) / 3
    # p e

    d = self.total_downloads.to_f / Project::LARAVEL_BASE['downloads']
    # p d

    self.popularity = ((e + d) / 2 * 100).round(4)
    
    if self.changed?
      self.save
    end
  end

  def self.set_pod_popularity
    self.pod.joins(:github_info, :pod_info).distinct.each do |project|
      if project.github_info.blank? || project.pod_info.blank?
        next
      end

      project.set_pod_popularity
      project.save!
    end
  end

  def set_pod_popularity
    # p self.id
    a = self.subscribers_count.to_f / Project::SWIFT_BASE['stars']
    # p a
    b = self.watchers_count.to_f / Project::SWIFT_BASE['watchers']
    # p b
    c = self.forks_count.to_f / Project::SWIFT_BASE['forks']
    # p c

    e = (a + b + c) / 3
    # p e

    d = self.total_downloads.to_f / Project::SWIFT_BASE['downloads']
    # p d

    self.popularity = ((e + d) / 2 * 100).round(4)
    
    if self.changed?
      self.save
    end
  end

  def detect_and_set_recommend_at
    if self.today_recommend_changed? && self.today_recommend?
      self.touch :recommend_at

      ::Episode.delay.change_project_list_for(self.id)
    end
  end

  def subscribers_count
    self.github_info.try(:subscribers_count) || 0
  end

  def watchers_count
    self.github_info.try(:watchers_count) || 0
  end

  def forks_count
    self.github_info.try(:forks_count) || 0
  end

  def total_downloads
    if self.gemspec?
      return self.gem_info.try(:total_downloads) || 0
    end

    if self.package?
      return self.package_info.try(:total_downloads) || 0
    end

    if self.pod?
      return self.pod_info.try(:total_downloads) || 0
    end
  end

  def had_star_by?(user)
    UserStarProject.had_star_by?(self, user)
  end

  def had_recommend_by?(user)
    UserRecommendProject.had_recommend_by?(self, user)
  end

  def set_readme
    self.github_info.set_readme
  end

  def self.set_all_github_info
    Project.includes(:github_info).where(github_infos: {id: nil}).find_each do |project|
      Project.delay.set_github_info(project.id)
    end
  end

  def self.set_github_info(project_id)
    project = Project.find(project_id)

    if project.github_info.blank?
      project.set_github_info
    end
  end

  def set_github_info
    if self.github_info.blank?
      self.build_github_info
    end

    self.set_description
    self.set_github_others_info
    self.set_raking_data

    self.github_info.save

    self.set_readme


    self.github_info.save
  end

  def split_github
    self.source_code.split("/")
  end

  def set_github_identity
    self.author = split_github[-2]
    self.name = split_github[-1]
  end

  def repo_params
    {code: self.code, slug: self.slug}
  end

  def convert_github_to_repo_url
    author_name = split_github[-2]
    repo_name = split_github[-1]

    unless "github.com" == split_github[-3]
      return ""
    end

    API_GITHUB + ("repos/#{author_name}/#{repo_name}")
  end

  def fetch_info_from_github
    url = convert_github_to_repo_url

    unless url =~ /github\.com/
      return {}
    end

    url += "?client_id=#{Settings.github_token}&client_secret=#{Settings.github_secret}"

    @json ||= Timeout.timeout(10) do
      begin
        open(url).read
      rescue OpenURI::HTTPError => e
        return {}
      end
    end

    parse_json = JSON.parse @json
  end

  # https://api.github.com/repos/rails/rails/contents/
  def get_gem_name
    url = convert_github_to_repo_url + "/contents"
    url += "?client_id=#{Settings.github_token}&client_secret=#{Settings.github_secret}"

    @json ||= Timeout.timeout(10) do
      begin
        open(url).read
      rescue OpenURI::HTTPError => e
        return ""
      end
    end

    parse_json = JSON.parse @json

    gemspec = parse_json.map{|x| x['name'] }.select{|xx| xx =~ /\.gemspec$/}

    if gemspec.blank?
      self.not_want!
      return ""
    end

    if self.github_info.present?
      self.github_info.others['gemspec'] = gemspec.join(',')
    end

    gemspec.first.gsub(/\.gemspec$/, "")
  end

  def self.delay_set_given_name(project_id)
    project = Project.find(project_id)

    project.set_given_name
  end

  def set_given_name
    self.given_name = self.get_gem_name

    if self.given_name_changed?
      self.save
    end
  end

  # 误杀太多，先不调用
  def self.batch_set_offline_gems_given_name
    self.gemspec.offline.find_each do |project|
      if project.gem_info.present?
        next
      end

      self.delay.delay_set_given_name(project.id)
      project.not_want!
    end
  end

  def set_github_others_info
    self.github_info.others = fetch_info_from_github.except('name', 'description',
      'subscribers_count', 'watchers_count', 'forks_count')
  end

  def set_name
    self.name = fetch_info_from_github["name"]
  end

  def set_description
    self.description = fetch_info_from_github["description"]
  end

  def set_website
    # self.homepage = fetch_info_from_github["homepage"]
  end

  def set_raking_data
    # subscribers_count =~ Watch
    self.github_info.subscribers_count = fetch_info_from_github["watchers_count"]
    # watchers_count =~ Star
    self.github_info.watchers_count = fetch_info_from_github["subscribers_count"]
    # forks_count =~ Fork
    self.github_info.forks_count = fetch_info_from_github["forks_count"]

    # self.last_updated_at = fetch_info_from_github["updated_at"]
    # self.updated_at = Time.now
  end

  def valid_identity?
    self.category.present? & self.category.catalog.present?
  end

  def set_project_type
    case self.category.catalog.type
    when "RailsCatalog"
      self.identity = 'gemspec'
    when "LaravelCatalog"
      self.identity = 'package'
    when "SwiftCatalog"
      self.identity = 'pod'
    else
      #
    end
  end

  def logic_set_gem_info
    if self.gemspec?
      self.set_gem_info
    end

    true
  end

  def set_gem_info(gem_name="")
    if gem_name.present?
      url = "https://rubygems.org/api/v1/gems/#{gem_name}.json"
    elsif self.given_name.present?
      url = "https://rubygems.org/api/v1/gems/#{given_name}.json"
    else
      url = "https://rubygems.org/api/v1/gems/#{name}.json"
    end

    uri = URI.parse(url)

    begin
      content = uri.read
      _gem_info = JSON.parse content
    rescue Exception => e
      _gem_info = {}
      return
    end

    gem_info = self.build_gem_info

    gem_info.total_downloads = _gem_info['downloads']
    gem_info.releases = ''
    gem_info.current_version = _gem_info['version']
    gem_info.released = ''
    gem_info.first_release = ''
    gem_info.others = _gem_info.except('name', 'downloads', 'version')

    gem_info.save
  end

  def logic_set_pod_info
    if self.pod?
      self.set_pod_info
    end
  end

  def set_pod_info
    _pod_info = self.build_pod_info

    if self.given_name.present?
      _pod_info.set_pod_info(self.given_name)
    else
      _pod_info.set_pod_info(self.name)
    end


    if _pod_info.others.present?
      _pod_info.save
    else
      self.offline!
    end
  end

  def logic_set_package_info
    if self.package?
      self.set_package_info
    end
  end

  def set_package_info
    _package_info = self.build_package_info

    _package_info.set_package_info(self.author, self.name)
    _package_info.save
  end

  def self.set_info
    pod_ps = self.where(id: (Project.pod.pending.ids - Project.pod.pending.joins(:pod_info).ids))
    pod_ps.each do |project|
      self.delay.set_pod_info(project.id)
    end

    pod_ps.update_all(status: ::Project.statuses['offline'])

    package_ps = self.where(id: (Project.package.pending.ids - Project.package.pending.joins(:package_info).ids))
    package_ps.each do |project|
      self.delay.set_package_info(project.id)
    end

    package_ps.update_all(status: ::Project.statuses['offline'])

    gemspec_ps = self.where(id: (Project.gemspec.pending.ids - Project.gemspec.pending.joins(:gem_info).ids))
    gemspec_ps.each do |project|
      self.delay.set_gem_info(project.id)
    end

    gemspec_ps.update_all(status: ::Project.statuses['offline'])
  end

  def self.set_pod_info(project_id)
    project = Project.find(project_id)
    project.set_pod_info

    if project.pod_info.present?
      project.online!
    end
  end

  def self.set_gem_info(project_id)
    project = Project.find(project_id)
    project.set_gem_info

    if project.gem_info.present?
      project.online!
    end
  end

  def self.set_package_info(project_id)
    project = Project.find(project_id)
    project.set_package_info

    if project.package_info.present?
      project.online!
    end
  end

  def self.get_and_create_gem_project(name, category_id)
    url = "https://www.ruby-toolbox.com/projects/#{name}"

    doc = Nokogiri::HTML(` curl "#{url}" `)

    x = doc.css("#content .github_repo h4>a")

    github_url = x.attribute("href").value

    self.get_and_create_gem_project_from(github_url, category_id)
  end

  def self.get_and_create_gem_project_from(github_url, category_id)
    self.create(source_code: github_url, identity: Project.identities['gemspec'], category_id: category_id)
  end

  def self.get_and_create_gem_project_from_option(options={})
    self.create(options)
  end

  def self.get_and_create_pod_project(github_url, category_id)
    # url = "https://www.ruby-toolbox.com/projects/#{name}"

    # doc = Nokogiri::HTML(` curl "#{url}" `)

    # x = doc.css("#content .github_repo h4>a")

    # github_url = x.attribute("href").value

    self.create(source_code: github_url, identity: Project.identities['pod'], category_id: category_id)
  end

  def to_param
    "#{self.code}-#{self.slug}"
  end

  def self.pending_detect_and_set_online
    Project.pending.includes(:gem_info, :package_info, :pod_info).joins(:github_info).each do |project|
      project.set_popularity_and_status
    end
  end

  def set_popularity_and_status
    if self.gemspec?
      if self.gem_info.present?
        self.set_gem_popularity

        if self.subscribers_count > 100
          self.online!
        else
          self.nightspot!
        end
      end
    end

    if self.package?
      if self.package_info.present?
        self.set_package_popularity

        if self.subscribers_count > 100
          self.online!
        else
          self.nightspot!
        end
      end
    end

    if self.pod?
      if self.pod_info.present?
        self.set_pod_popularity

        if self.subscribers_count > 100
          self.online!
        else
          self.nightspot!
        end
      end
    end
  end

  def logic_set_info
    if self.gemspec?
      self.set_gem_info
    end

    if self.package?
      self.set_package_info
    end

    if self.pod?
      self.set_pod_info
    end
  end

  def delay_set_developer_info
    delay = rand(1..3600)
    Developer.delay_for(delay).set_developer_info(self.id)
  end

  def aysc_set_developer_info
    Developer.delay.set_developer_info(self.id)
  end

  def relate_info
    case self.identity
    when 'gemspec'
      self.gem_info
    when 'pod'
      self.pod_info
    when 'package'
      self.package_info
    else
      nil
    end
  end

  def show_name
    self.human_name.presence || self.name
  end

  def show_homepage
    case self.identity
    when 'gemspec'
      github_info.others['homepage'].presence || gem_info.others['homepage_uri'].presence
    when 'pod'
      github_info.others['homepage'].presence
    when 'package'
      # ...
    else
      # ...
    end
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '-')
  end

  mapping do
    indexes :id, type: :integer

    indexes :identity
    indexes :status

    indexes :name
    indexes :given_name
    indexes :human_name

    indexes :description
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:id,
        :identity, :status,
        :name, :given_name, :human_name,
        :description],

      include: { category: { only: [:name, :slug]}}
    )
  end
end
