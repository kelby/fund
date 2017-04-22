# == Schema Information
#
# Table name: fundcompany_snapshots
#
#  id                               :integer          not null, primary key
#  fundcompany_id                   :integer
#  name                             :string(255)
#  city                             :string(255)
#  set_up_at                        :date
#  scale                            :decimal(10, )
#  funds_count                      :integer
#  managers_count                   :integer
#  tenure_avg                       :string(255)
#  this_year_best_fund_id           :integer
#  this_year_best_fund_total_return :decimal(10, )
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#

class FundcompanySnapshot < ApplicationRecord
end
