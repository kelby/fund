class PackageInfo < ApplicationRecord
  # from https://packagist.org/search/?tags=laravel
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

  belongs_to :project
end
