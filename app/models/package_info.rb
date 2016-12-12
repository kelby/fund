# == Schema Information
#
# Table name: package_infos
#
#  id              :integer          not null, primary key
#  project_id      :integer
#  total_downloads :decimal(10, )
#  releases        :integer
#  current_version :string(255)
#  released        :datetime
#  first_release   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  others          :text(16777215)
#

class PackageInfo < ApplicationRecord
  # https://packagist.org/search/?tags=laravel
  # https://packagist.org/packages/[vendor]/[package].json

  # https://api.github.com/
  # /repos/:owner/:repo/contents/:path


  # {
  #   "package": {
  #     "name": "[vendor]/[package],
  #     "description": [description],
  #     "time": [time of the last release],
  #     "maintainers": [list of maintainers],
  #     "versions": [list of versions and their dependencies, the same data of composer.json]
  #     "type": [package type],
  #     "repository": [repository url],
  #     "downloads": {
  #       "total": [numbers of download],
  #       "monthly": [numbers of download per month],
  #       "daily": [numbers of download per day]
  #     },
  #     "favers": [number of favers]
  #   }
  # }

  # version
  # requires, requires (dev), suggests
  # provides, conflicts, replaces

  # lisence, hash
  # author, author_email
  # tags

  # readme

  # # github
  # Issues_url, Source_url
  # Installs, Dependents, Suggesters
  # Stars, Watchers, Forks, Open Issues
  serialize :others, JSON

  belongs_to :project

  COMPOSER_URL = "https://api.github.com/repos/:owner/:repo/contents/:path"

  def get_vendor_and_package(author, name)
    if self.others.present? && self.others['composer'].present?
      _content = self.others['composer']
    else
      path = "composer.json"

      url = "#{PackageInfo::COMPOSER_URL.gsub(/:owner/, author).gsub(/:repo/, name).gsub(/:path/, path)}"


      begin
        _composer = open(url).read
      rescue OpenURI::HTTPError => e
        _composer = ""
      end

      composer = JSON.parse(_composer)


      content = Base64.decode64(composer['content'])

      self.others ||= {}
      self.others['composer'] = _content

      _content = JSON.parse(content)
    end

    _content['name'].split('/')
  end

  API_URL = "https://packagist.org/packages/[vendor]/[package].json"
  def get_package_info(author, name)
    vendor, package = get_vendor_and_package(author, name)

    url = PackageInfo::API_URL.gsub(/\[vendor\]/, vendor).gsub(/\[package\]/, package)


    begin
      api_content = open(url).read
    rescue OpenURI::HTTPError => e
      api_content = ""
    end

    json_content = JSON.parse(api_content)
    json_content
  end

  REGEX = /(^dev-)|(-dev$)/

  def set_package_info(vendor, package)
    json_content = get_package_info(vendor, package)

    package_info = json_content['package']
    # self.total_downloads = json_content['downloads']

    package_info["version"] = {}
    # bebugger
    # binding.pry
    regex = /(^dev-)|(-dev$)/

    key, value = package_info["versions"].select{|key, _| (key =~ PackageInfo::REGEX)}.first
    package_info["version"][key] = value
    key, value = package_info["versions"].select{|key, _| !(key =~ PackageInfo::REGEX)}.first
    package_info["version"][key] = value

    # package_info["version"].merge(   package_info["versions"].select{|key, _| (key =~ /(^dev-)|(-dev$)/)   }.first)
    # package_info["version"].merge(   package_info["versions"].select{|key, _| !(key =~ /(^dev-)|(-dev$)/)   }.first)

    self.others = package_info.except("versions")
  end

  def get_version
    self.others['version'].keys.select{|key| !(key =~ PackageInfo::REGEX) }.first
  end

  def self.get_package_info(vendor, package)
    url = PackageInfo::API_URL.gsub(/\[vendor\]/, vendor).gsub(/\[package\]/, package)


    begin
      api_content = open(url).read
    rescue OpenURI::HTTPError => e
      api_content = ""
    end


    json_content = JSON.parse(api_content)
    json_content
  end

  def self.get_project_github_url(vendor, package)
    json_content = self.get_package_info(vendor, package)

    package_info = json_content['package']

    package_info['repository']
  end
end
