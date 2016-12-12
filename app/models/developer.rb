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
  has_many :projects

  def self.create_developer_from_projects
    Project.joins(:github_info).find_each do |project|
      developer = Developer.find_or_create_by(name: project.author)

      project.update_columns(developer_id: developer.id)
    end
  end
end
