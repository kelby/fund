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
#  fund_fen_hongs_count :integer          default(0)
#  yield_type           :integer          default("yield_type_unknow")
#  yield_rate           :decimal(15, 4)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class FundYield < ApplicationRecord
  belongs_to :project

  validates_presence_of :project_id
  validates_presence_of :beginning_day
  validates_presence_of :end_day

  validates_uniqueness_of :yield_type, scope: :project_id


  enum yield_type: { yield_type_unknow: 0,
    last_one_week: 1,
    last_one_month: 3, last_two_month: 5, last_three_month: 7, last_six_month: 9,
    last_one_year: 13, last_two_year: 15, last_three_year: 17, this_year: 19,
    last_five_year: 21, last_seven_year: 23, last_ten_year: 25,
    since_the_inception: 33}


  YIELD_TYPE_HASH = {
    'yield_type_unknow' => "",
    'last_one_week' => "近1周",
    'last_one_month' => "近1月",
    'last_two_month' => "近2月",
    'last_three_month' => "近3月",
    'last_six_month' => "近6月",
    'last_one_year' => "近1年",
    'last_two_year' => "近2年",
    'last_three_year' => "近3年",
    'this_year' => "今年来",
    'last_five_year' => "近5年",
    'last_seven_year' => "近7年",
    'last_ten_year' => "近10年",
    'since_the_inception' => "成立来"
  }


  def date_range
    self.beginning_day..self.end_day
  end

  def fund_fen_hongs
    self.project.fund_fen_hongs.where(ex_dividend_at: self.date_range)
  end

  def fund_chai_fens
    self.project.fund_chai_fens.where(break_convert_at: self.date_range)
  end

  def yield_rate_color
    if self.yield_rate.blank?
      return
    end

    if self.yield_rate > 0
      'red'
    elsif self.yield_rate < 0
      'green'
    else
      # ...
    end
  end
end
