# == Schema Information
#
# Table name: fund_rankings
#
#  id                                    :integer          not null, primary key
#  project_id                            :integer
#  code                                  :string(255)
#  name                                  :string(255)
#  dwjz                                  :decimal(10, )
#  three_year_rating                     :integer
#  five_year_rating                      :integer
#  last_week_total_return                :decimal(10, )
#  last_week_ranking                     :integer
#  last_month_total_return               :decimal(10, )
#  last_month_ranking                    :integer
#  last_three_month_total_return         :decimal(10, )
#  last_three_month_ranking              :integer
#  last_six_month_total_return           :decimal(10, )
#  last_six_month_ranking                :integer
#  last_year_total_return                :decimal(10, )
#  last_year_ranking                     :integer
#  last_two_year_total_return            :decimal(10, )
#  last_two_year_ranking                 :integer
#  this_year_total_return                :decimal(10, )
#  this_year_ranking                     :integer
#  since_the_inception_total_return      :decimal(10, )
#  last_three_year_volatility            :decimal(10, )
#  last_three_year_volatility_evaluate   :string(255)
#  last_three_year_risk_factor           :decimal(10, )
#  last_three_year_risk_factor_evaluate  :string(255)
#  last_three_year_sharpe_ratio          :decimal(10, )
#  last_three_year_sharpe_ratio_evaluate :string(255)
#  record_at                             :date
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#

class FundRanking < ApplicationRecord
end
