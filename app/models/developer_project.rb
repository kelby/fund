# == Schema Information
#
# Table name: developer_projects
#
#  id                  :integer          not null, primary key
#  developer_id        :integer
#  project_id          :integer
#  beginning_work_date :date
#  end_of_work_date    :date
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class DeveloperProject < ApplicationRecord
  belongs_to :developer
  belongs_to :project

  validates_presence_of :developer_id, :project_id
  # 可以没有 end_of_work_date
  validates_presence_of :beginning_work_date
  validates_uniqueness_of :project_id, scope: :developer_id
end
