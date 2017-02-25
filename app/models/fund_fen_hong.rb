# == Schema Information
#
# Table name: fund_fen_hongs
#
#  id                       :integer          not null, primary key
#  register_at              :date
#  ex_dividend_at           :date
#  bonus_per                :string(255)
#  dividend_distribution_at :date
#  project_id               :integer
#  net_worth_id             :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  bonus                    :decimal(15, 4)
#

class FundFenHong < ApplicationRecord
  # validates_presence_of :net_worth_id # 实际情况，不是完全对应

  validates_presence_of :register_at, :ex_dividend_at

  validates_presence_of :bonus_per, if: Proc.new{|fund_fen_hong| fund_fen_hong.bonus.blank?}
  validates_presence_of :bonus, if: Proc.new{|fund_fen_hong| fund_fen_hong.bonus_per.blank?}

  validates_uniqueness_of :net_worth_id, allow_blank: true


  belongs_to :project, counter_cache: true
  belongs_to :net_worth

  # 实际情况，不是完全对应
  def dwjz
    self.project.net_worths.find_by(record_at: self.ex_dividend_at).try(:dwjz)
  end
end
