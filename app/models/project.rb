# == Schema Information
#
# Table name: projects
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :text(16777215)
#  website         :string(255)
#  wiki            :string(255)
#  source_code     :string(255)
#  category_id     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  identity        :integer          default("unknow")
#  author          :text(16777215)
#  status          :integer          default("pending")
#  popularity      :decimal(15, 2)
#  developer_id    :integer
#  today_recommend :boolean
#  recommend_at    :datetime
#

require 'elasticsearch/model'

class Project < ApplicationRecord
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  # Associations
  belongs_to :category # , counter_cache: true
  counter_culture :category
  counter_culture :category, :column_name => proc {|model| model.online? ? 'online_projects_count' : nil }

  belongs_to :developer

  has_one :github_info

  has_one :gem_info
  has_one :pod_info
  has_one :package_info

  has_many :comments, as: :commentable

  has_many :user_star_projects
  has_many :user_recommend_projects

  has_many :star_by_users, through: :user_star_projects, source: :user
  has_many :recommend_by_users, through: :user_recommend_projects, source: :user
  # END


  # Rails class methods
  enum identity: {unknow: 0, gem: 2, package: 4, pod: 6}
  # 等待处理，下线，上线；Star 数目小于100
  enum status: {pending: 0, offline: 4, online: 6, nightspot: 8}

  scope :nolimit, -> { unscope(:limit, :offset) }
  # END


  # Validates
  validates_presence_of :source_code
  # validates_presence_of :category_id

  validates_uniqueness_of :name, scope: :author, message: "该用户的项目已经存在，您不必重复添加"
  # END


  # Callbacks
  after_commit :logic_set_gem_info, on: :create
  after_commit :logic_set_pod_info, on: :create
  after_commit :logic_set_package_info, on: :create

  after_commit :set_github_info, on: :create

  after_commit :delay_set_developer_info, on: :create
  # after_commit :set_readme, on: :create

  # after_create :build_github_info

  before_validation :set_github_identity

  after_update :detect_and_set_recommend_at
  # END


  # Constants
  API_GITHUB = "https://api.github.com/"

  RAILS_BASE = {'watchers' => 2321, 'stars' => 33566, 'forks' => 13698, 'downloads' => 81138762}
  SWIFT_BASE = {'watchers' => 2406, 'stars' => 35406, 'forks' => 5135, 'downloads' => 81138762}
  LARAVEL_BASE = {'watchers' => 3522, 'stars' => 27582, 'forks' => 9131, 'downloads' => 3941137}
  # END

  def self.set_gem_popularity
    self.gem.joins(:github_info, :gem_info).distinct.each do |project|
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
      self.touch! :recommend_at
    end
  end

  def subscribers_count
    self.github_info.subscribers_count || 0
  end

  def watchers_count
    self.github_info.watchers_count || 0
  end

  def forks_count
    self.github_info.forks_count || 0
  end

  def total_downloads
    if self.gem?
      return self.gem_info.total_downloads || 0
    end

    if self.package?
      return self.package_info.total_downloads || 0
    end

    if self.pod?
      return self.pod_info.total_downloads || 0
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
    Project.find_each do |project|
      if project.github_info.blank?
        project.set_github_info
      end

      if project.github_info.blank?
        project.online!
      else
        project.offline!
      end
    end
  end

  def self.set_github_info(project_id)
    project = Project.find(project_id)

    if project.github_info.blank?
      project.set_github_info
    end

    if project.github_info.blank?
      project.online!
    else
      project.offline!
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
    {name: self.name, author: self.author}
  end

  def convert_github_to_repo_url
    author_name = split_github[-2]
    repo_name = split_github[-1]

    unless "github.com" == split_github[-3]
      return false
    end

    API_GITHUB + ("repos/#{author_name}/#{repo_name}")
  end

  def fetch_info_from_github
    url = convert_github_to_repo_url

    url += "?client_id=#{Settings.github_token}&client_secret=#{Settings.github_secret}"

    @json ||= Timeout.timeout(10) do
      open(url).read
    end

    parse_json = JSON.parse @json
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
      self.identity = 'gem'
    when "LaravelCatalog"
      self.identity = 'package'
    when "SwiftCatalog"
      self.identity = 'pod'
    else
      #
    end
  end

  def logic_set_gem_info
    if self.gem?
      self.set_gem_info
    end

    true
  end

  def set_gem_info
    url = "https://rubygems.org/api/v1/gems/#{name}.json"

    uri = URI.parse(url)

    content = uri.read
    _gem_info = JSON.parse content

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

    _pod_info.set_pod_info(self.name)
    _pod_info.save
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
    ps = self.where(id: (Project.pod.pending.ids - Project.pod.pending.joins(:pod_info).ids))
    ps.each do |project|
      self.delay.set_pod_info(project.id)
    end

    ps.update_all(status: ::Project.statuses['offline'])

    ps = self.where(id: (Project.package.pending.ids - Project.package.pending.joins(:package_info).ids))
    ps.each do |project|
      self.delay.set_package_info(project.id)
    end

    ps.update_all(status: ::Project.statuses['offline'])

    ps = self.where(id: (Project.gem.pending.ids - Project.gem.pending.joins(:gem_info).ids))
    ps.each do |project|
      self.delay.set_gem_info(project.id)
    end

    ps.update_all(status: ::Project.statuses['offline'])
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
    self.create(source_code: github_url, identity: Project.identities['gem'], category_id: category_id)
  end

  def self.get_and_create_gem_project_from_option(options={})
    self.create(source_code: options['source_code'], identity: options['identity'])
  end

  def self.get_and_create_pod_project(github_url, category_id)
    # url = "https://www.ruby-toolbox.com/projects/#{name}"

    # doc = Nokogiri::HTML(` curl "#{url}" `)

    # x = doc.css("#content .github_repo h4>a")

    # github_url = x.attribute("href").value

    self.create(source_code: github_url, identity: Project.identities['pod'], category_id: category_id)
  end
  # def to_param
    # "#{self.id}-#{self.name}"
  # end

  def self.detect_and_set_online
    Project.includes(:gem_info, :package_info, :pod_info).joins(:github_info).each do |project|
      if project.gem?
        if project.gem_info.present?
          project.set_gem_popularity

          if project.subscribers_count > 100
            project.online!
          else
            project.nightspot!
          end
        end
      end

      if project.package?
        if project.package_info.present?
          project.set_package_popularity

          if project.subscribers_count > 100
            project.online!
          else
            project.nightspot!
          end
        end
      end

      if project.pod?
        if project.pod_info.present?
          project.set_pod_popularity

          if project.subscribers_count > 100
            project.online!
          else
            project.nightspot!
          end
        end
      end
    end
  end

  def delay_set_developer_info
    Developer.delay.set_developer_info(self.id)
  end

  def relate_info
    if self.gem?
      self.gem_info
    elsif self.pod?
      self.pod_info
    elsif self.package?
      self.package_info
    else
      nil
    end
  end
end
