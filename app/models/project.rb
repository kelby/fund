# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  website     :string(255)
#  wiki        :string(255)
#  source_code :string(255)
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  identity    :integer          default("unknow")
#  author      :text(65535)
#

class Project < ApplicationRecord
  belongs_to :category

  has_one :github_info

  has_one :gem_info
  has_one :pod_info
  has_one :package_info

  enum identity: {unknow: 0, gem: 2, package: 4, pod: 6}

  validates_presence_of :source_code
  # validates_presence_of :category_id

  validates_uniqueness_of :name, scope: :author, message: "该用户的项目已经存在，您不必重复添加"

  after_commit :logic_set_gem_info, on: :create
  after_commit :logic_set_pod_info, on: :create
  after_commit :logic_set_package_info, on: :create

  after_commit :set_github_info, on: :create

  # after_create :build_github_info

  before_validation :set_github_identity

  API_GITHUB = "https://api.github.com/"

  def set_github_info
    self.build_github_info

    self.set_description
    self.set_github_others_info
    self.set_raking_data

    self.github_info.save
  end

  def split_github
    split_github = self.source_code.split("/")
  end

  def set_github_identity
    self.author = split_github[-2]
    self.name = split_github[-1]
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
    self.github_info.subscribers_count = fetch_info_from_github["subscribers_count"]
    self.github_info.watchers_count = fetch_info_from_github["watchers_count"]
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
end
