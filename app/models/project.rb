class Project < ApplicationRecord
  belongs_to :category

  has_one :github_info

  has_one :gem_info
  has_one :pod_info
  has_one :package_info

  validates_presence_of :source_code
  validates_presence_of :category_id

  after_commit :logic_set_gem_info, on: :create
  after_commit :logic_set_pod_info, on: :create

  def logic_set_gem_info
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
  end

  def set_pod_info
  end

  def logic_set_package_info
  end

  def set_package_info
  end
end
