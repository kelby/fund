# == Schema Information
#
# Table name: developers
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  avatar            :string(255)
#  github_id         :integer
#  public_repos      :integer
#  subscribers_count :integer
#  watchers_count    :integer
#  forks_count       :integer
#  identity          :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Developer < ApplicationRecord
  # Associations
  has_many :projects
  # END


  # Plugins
  mount_uploader :avatar, AvatarUploader
  # END


  # Constants
  GITHUB_URL = "https://github.com/"
  # END


  # Callbacks
  after_create :set_avatar
  after_create :set_projects_data
  # END


  def self.create_developer_from_projects
    Project.joins(:github_info).find_each do |project|
      developer = Developer.find_or_create_by(name: project.author)

      project.update_columns(developer_id: developer.id)
    end
  end

  def self.set_developer_info(project_id)
    project = Project.find(project_id)

    developer = Developer.find_or_create_by(name: project.author)

    project.update_columns(developer_id: developer.id)
  end

  def set_avatar
    if self.avatar.file.blank?
      begin
        self.remote_avatar_url = self.projects.last.github_info['others']['owner']['avatar_url']
        self.save
      rescue Exception => e
        # ...
      end
    end
  end

  def self.set_projects_data(developer_id)
    developer = Developer.find(developer_id)

    developer.set_projects_data

    if developer.changed?
      developer.save
    end
  end

  def set_projects_data
    self.subscribers_count = GithubInfo.where(project_id: project_ids).sum(:subscribers_count)
    self.watchers_count = GithubInfo.where(project_id: project_ids).sum(:watchers_count)
    self.forks_count = GithubInfo.where(project_id: project_ids).sum(:forks_count)

    if self.changed?
      self.save
    end
  end

  def project_ids
    self.projects.ids
  end
end
