# == Schema Information
#
# Table name: user_recommend_projects
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserRecommendProject < ApplicationRecord
  validates_presence_of :user_id, :project_id
  validates_uniqueness_of :user_id, scope: :project_id

  belongs_to :user
  belongs_to :project
end
