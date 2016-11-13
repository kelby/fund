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
#

class GithubInfo < ApplicationRecord
  # from https://developer.github.com/v3/

  belongs_to :project, autosave: true
end
