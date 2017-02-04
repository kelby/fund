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
#

class FundFenHong < ApplicationRecord
  validates_presence_of :net_worth_id
  validates_presence_of :ex_dividend_at, :bonus_per

  validates_uniqueness_of :net_worth_id


  belongs_to :project
  belongs_to :net_worth
end