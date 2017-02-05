# == Schema Information
#
# Table name: fund_rankings
#
#  id                                    :integer          not null, primary key
#  project_id                            :integer
#  code                                  :string(255)
#  name                                  :string(255)
#  dwjz                                  :decimal(15, 4)
#  three_year_rating                     :integer
#  five_year_rating                      :integer
#  last_week_total_return                :decimal(15, 4)
#  last_week_ranking                     :integer
#  last_month_total_return               :decimal(15, 4)
#  last_month_ranking                    :integer
#  last_three_month_total_return         :decimal(15, 4)
#  last_three_month_ranking              :integer
#  last_six_month_total_return           :decimal(15, 4)
#  last_six_month_ranking                :integer
#  last_year_total_return                :decimal(15, 4)
#  last_year_ranking                     :integer
#  last_two_year_total_return            :decimal(15, 4)
#  last_two_year_ranking                 :integer
#  this_year_total_return                :decimal(15, 4)
#  this_year_ranking                     :integer
#  since_the_inception_total_return      :decimal(15, 4)
#  last_three_year_volatility            :decimal(15, 4)
#  last_three_year_volatility_evaluate   :string(255)
#  last_three_year_risk_factor           :decimal(15, 4)
#  last_three_year_risk_factor_evaluate  :string(255)
#  last_three_year_sharpe_ratio          :decimal(15, 4)
#  last_three_year_sharpe_ratio_evaluate :string(255)
#  record_at                             :date
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  fund_type                             :string(255)
#  evaluate_type                         :string(255)
#  two_year_rating                       :integer
#  one_year_rating                       :integer
#  last_one_year_volatility              :decimal(15, 4)
#  last_one_year_volatility_evaluate     :string(255)
#  last_one_year_risk_factor             :decimal(15, 4)
#  last_one_year_risk_factor_evaluate    :string(255)
#  last_one_year_sharpe_ratio            :decimal(15, 4)
#  last_one_year_sharpe_ratio_evaluate   :string(255)
#

class FundRanking < ApplicationRecord
  # Associations
  belongs_to :project


  # Validates
  validates_presence_of :code
  validates_presence_of :record_at

  validates_uniqueness_of :record_at, scope: :code


  # Callbacks
  after_create :set_project_id

  def set_project_id
    project = Project.find_by(code: self.code)

    if project.present?
      self.update_columns(project_id: project.id)
    end
  end
end
