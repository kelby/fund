# == Schema Information
#
# Table name: gem_infos
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
#  others          :text(65535)
#

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
  serialize :others, JSON

  API_URL = "http://guides.rubygems.org/rubygems-org-api/"

  belongs_to :project

  GEM_INFO_URL = "https://rubygems.org/api/v1/gems/"
  def get_gem_info(name)
    url = "#{GemInfo::GEM_INFO_URL}#{name}.json"

    api_content = open(url).read

    json_content = JSON.parse(api_content)
    json_content
  end

  def set_gem_info(name)
    json_content = get_gem_info(name)

    self.total_downloads = json_content['downloads']
    # self.releases = json_content['xxx']
    self.current_version = json_content['version']
    # self.released = json_content['xxx']
    # self.first_release = json_content['xxx']

    self.others = json_content.except('downloads', 'version')
  end

  REVERSE_DEPENDENCIES_URL = "https://rubygems.org/api/v1/gems/shoulda/reverse_dependencies.json"
  def get_reverse_dependencies(name)
    url = "#{GemInfo::REVERSE_DEPENDENCIES_URL.gsub('shoulda', name)}"
    api_content = open(url).read

    JSON.parse(api_content)
  end

  def set_reverse_dependencies(name)
    json_content = get_reverse_dependencies(name)

    self.others['reverse_dependencies'] = json_content
  end

  VERSIONS_URL = "https://rubygems.org/api/v1/versions/coulda.json"
  def get_versions(name)
    url = "#{GemInfo::VERSIONS_URL.gsub('coulda', name)}"
    api_content = open(url).read

    JSON.parse(api_content)
  end

  def set_versions(name)
    json_content = get_versions(name)
    self.others['versions'] = json_content
  end
end
