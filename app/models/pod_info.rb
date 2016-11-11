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


  belongs_to :project

  def self.set_pod_info
  end
end
