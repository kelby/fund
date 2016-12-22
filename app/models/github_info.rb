# == Schema Information
#
# Table name: github_infos
#
#  id                :integer          not null, primary key
#  project_id        :integer
#  subscribers_count :integer
#  watchers_count    :integer
#  forks_count       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  others            :text(65535)
#  readme            :text(65535)
#

class GithubInfo < ApplicationRecord
  # from https://developer.github.com/v3/

  # Associations
  belongs_to :project, autosave: true
  # END


  # Rails class methods
  serialize :others, JSON

  scope :none_data, ->{ where("subscribers_count = ? OR watchers_count = ? OR forks_count = ?", nil, nil, nil) }
  # END


  # Validates
  validates_presence_of :subscribers_count, :watchers_count, :forks_count
  # END


  # Constants
  API_GITHUB = "https://api.github.com/"
  # END


  def self.set_online_project_nightspot(number=100)
    # number = 100

    self.where("subscribers_count < ?", number).includes(:project).where(projects: {status: Project.statuses['online']}).find_each do |this|
      if this.project.present?
        this.project.nightspot!
      end
    end
  end


  def split_github
    split_github = self.project.split_github
  end

  def convert_github_to_repo_url
    author_name = split_github[-2]
    repo_name = split_github[-1]

    unless "github.com" == split_github[-3]
      return ""
    end

    API_GITHUB + ("repos/#{author_name}/#{repo_name}")
  end

  def github_readme_url
    convert_github_to_repo_url + "/readme"
  end

  def fetch_reade_from_github
    url = github_readme_url
    url += "?client_id=#{Settings.github_token}&client_secret=#{Settings.github_secret}"

    unless github_readme_url =~ /github\.com/
      return {}
    end

    @reademe_json ||= Timeout.timeout(10) do
      begin
        open(url).read
      rescue OpenURI::HTTPError => e
        return {}
      end
    end

    if @reademe_json.present?
      parse_json = JSON.parse @reademe_json
    else
      parse_json = {}
    end
  end

  def set_some_count(not_force=true)
    return if self.project.blank?

    if not_force
      if self.subscribers_count.present? && self.watchers_count.present? && self.forks_count.present?
        return
      end
    end

    self.project.set_raking_data

    self.project.github_info.save
  end

  def set_readme
    content = fetch_reade_from_github["content"].presence || ""
    self.readme = Base64.decode64(content)
  end
end
