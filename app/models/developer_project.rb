# == Schema Information
#
# Table name: developer_projects
#
#  id                       :integer          not null, primary key
#  developer_id             :integer
#  project_id               :integer
#  beginning_work_date      :date
#  end_of_work_date         :date
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  developer_eastmoney_code :string(255)
#  developer_sina_code      :string(255)
#  project_code             :string(255)
#  term_of_office           :string(255)
#  as_return                :decimal(15, 4)
#

class DeveloperProject < ApplicationRecord
  belongs_to :developer
  belongs_to :project

  validates_presence_of :developer_id, :project_id
  # 可以没有 end_of_work_date
  validates_presence_of :beginning_work_date

  validates_uniqueness_of :project_id, scope: [:developer_id, :beginning_work_date]

  before_validation :detect_and_set_attributes

  def detect_and_set_attributes
    if self.project_code.present? && self.project_id.blank?
      self.project_id = Project.find_by(code: self.project_code).try(:id)
    end

    if self.developer_sina_code.present? && self.developer_id.blank?
      self.developer_id = Developer.find_by(sina_code: self.developer_sina_code).try(:id)
    end

    if self.developer_eastmoney_code.present? && self.developer_id.blank?
      self.developer_id = Developer.find_by(eastmoney_code: self.developer_eastmoney_code).try(:id)
    end
  end
end
