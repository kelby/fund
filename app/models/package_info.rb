class PackageInfo < ApplicationRecord
  # https://packagist.org/search/?tags=laravel
  # https://packagist.org/packages/[vendor]/[package].json


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


  API_URL = "https://packagist.org/packages/vendor/package.json"
  def get_package_info(vendor, package)
    url = "#{PackageInfo::API_URL.gsub('vendor', vendor).gsub('package', package)}"

    api_content = open(url).read

    json_content = JSON.parse(api_content)
    json_content
  end

  def set_package_info(vendor, package)
    json_content = get_package_info(vendor, package)

    package_info = json_content['package']
    # self.total_downloads = json_content['downloads']

    self.others = package_info
  end
end
