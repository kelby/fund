# == Schema Information
#
# Table name: quickrank_snapshots
#
#  id                     :integer          not null, primary key
#  rating_date            :date
#  project_id             :integer
#  project_code           :string(255)
#  morningstar_code       :string(255)
#  project_name           :string(255)
#  project_category       :string(255)
#  star_rating_five_year  :integer
#  star_rating_three_year :integer
#  record_at              :date
#  dwjz                   :decimal(15, 4)
#  iopv                   :decimal(15, 4)
#  yield_rate             :decimal(15, 4)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class QuickrankSnapshot < ApplicationRecord
  validates_presence_of :project_code
  validates_presence_of :rating_date
  validates_presence_of :morningstar_code
  validates_presence_of :project_name

  validates_uniqueness_of :rating_date, scope: :project_code

  after_create :set_project_id

  def set_project_id
    return true if self.project_id.present?

    _project = Project.find_by(code: self.project_code)

    if _project.present?
      self.update_columns project_id: _project.id
    end
  end
end
