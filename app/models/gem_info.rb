class GemInfo < ApplicationRecord
  # from https://rubygems.org/
  # http://guides.rubygems.org/rubygems-org-api/


  # ["name", "downloads",
  #   "version", "version_downloads",
  #   "platform", "authors",
  #   "info", "licenses",
  #   "metadata", "sha",
  #   "project_uri", "gem_uri",
  #   "homepage_uri", "wiki_uri",
  #   "documentation_uri", "mailing_list_uri",
  #   "source_code_uri", "bug_tracker_uri", "dependencies"]

  # https://rubygems.org/api/v1/gems/rails.json
  # https://rubygems.org/api/v1/gems/shoulda/reverse_dependencies.json
  # https://rubygems.org/api/v1/versions/coulda.json
  # https://rubygems.org/api/v1/versions/rails/latest.json
  # https://rubygems.org/api/v1/downloads.json
  # https://rubygems.org/api/v1/downloads/rails_admin-0.0.0.json


  belongs_to :project
end
