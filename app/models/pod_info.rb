# == Schema Information
#
# Table name: pod_infos
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

class PodInfo < ApplicationRecord
  # from https://cocoapods.org/
  # xxx.podspec.json
  # http://metrics.cocoapods.org/api/v1/pods/ORStackView

  # name, version
  # author, author_twitter
  # github_url, quality
  # overview, changelog
  # documented, tested, language, license, last_release
  # maintaines

  # # Downloads
  # total, week, month

  # # Installs
  # Apps, Apps This Week, Pod Tries, Pod Tries This Week, Test Targets, Tests This week, Watch Apps, Watch Apps This week

  # # GitHub
  # Stars, Watchers, Forks, Issues, Contributors, Pull Requests

  # # Code
  # Files, Integration Size, Creates Framework, Lines of Code

  # Podspec
  # Documentation, GitHub Repo, Page on CocoaPods.org

  # store :others, accessors: [ :color, :homepage ], coder: JSON
  serialize :others, JSON

  API_URL = "http://metrics.cocoapods.org/api/v1/pods/"


  belongs_to :project

  def get_api_info(name)
    url = "#{API_URL}#{name}"

    begin
      api_response = open(url).read
    rescue OpenURI::HTTPError => e
      api_response = ""
    end

    json_content = JSON.parse(api_response)

    json_content
  end

  def set_pod_info(name)
    json_content = get_api_info(name)

    # self.total_downloads = json_content['xxx']
    # self.releases = json_content['xxx']
    # self.current_version = json_content['xxx']
    # self.released = json_content['xxx']
    # self.first_release = json_content['xxx']

    self.others = json_content
  end
end
