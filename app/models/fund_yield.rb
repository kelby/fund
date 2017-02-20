# == Schema Information
#
# Table name: fund_yields
#
#  id                   :integer          not null, primary key
#  project_id           :integer
#  beginning_day        :date
#  end_day              :date
#  beginning_net_worth  :decimal(15, 4)
#  end_net_worth        :decimal(15, 4)
#  fund_chai_fens_count :integer          default(0)
#  fund_fen_hongs       :integer          default(0)
#  yield_type           :integer          default(0)
#  yield_rate           :decimal(15, 4)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class FundYield < ApplicationRecord
  belongs_to :project_id


  enum yield_type: { yield_type_unknow: 0,
    last_one_week: 1,
    last_one_month: 3, last_two_month: 5, last_three_month: 7, last_six_month: 9,
    last_one_year: 13, last_two_year: 15, last_three_year: 17, this_year: 19,
    last_five_year: 21, last_seven_year: 23, last_ten_year: 25,
    since_the_inception: 33}
end
