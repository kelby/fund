# == Schema Information
#
# Table name: user_star_projects
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserStarProject < ApplicationRecord
  validates_presence_of :user_id, :project_id
  validates_uniqueness_of :user_id, scope: :project_id

  belongs_to :user
  belongs_to :project

  def self.had_star_by?(project, user)
    self.where(project_id: project.id, user_id: user.id).present?
  end
end
