# == Schema Information
#
# Table name: quickrank_performances
#
#  id                               :integer          not null, primary key
#  rating_date                      :date
#  project_id                       :integer
#  project_code                     :string(255)
#  morningstar_code                 :string(255)
#  project_name                     :string(255)
#  last_day_total_return            :decimal(15, 4)
#  last_week_total_return           :decimal(15, 4)
#  last_month_total_return          :decimal(15, 4)
#  last_three_month_total_return    :decimal(15, 4)
#  last_six_month_total_return      :decimal(15, 4)
#  last_year_total_return           :decimal(15, 4)
#  last_two_year_total_return       :decimal(15, 4)
#  last_three_year_total_return     :decimal(15, 4)
#  last_five_year_total_return      :decimal(15, 4)
#  last_ten_year_total_return       :decimal(15, 4)
#  since_the_inception_total_return :decimal(15, 4)
#  three_year_volatility            :decimal(15, 4)
#  three_year_risk_factor           :decimal(15, 4)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#

class QuickrankPerformance < ApplicationRecord
  validates_presence_of :project_code
  validates_presence_of :rating_date
  validates_presence_of :morningstar_code
  validates_presence_of :project_name

  validates_uniqueness_of :rating_date, scope: :project_code


  after_create :set_project_id


  belongs_to :project


  def set_project_id
    return true if self.project_id.present?

    _project = Project.find_by(code: self.project_code)

    if _project.present?
      self.update_columns project_id: _project.id
    end
  end
end
