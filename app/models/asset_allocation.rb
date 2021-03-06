# == Schema Information
#
# Table name: asset_allocations
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  record_at   :date
#  stock_ratio :decimal(15, 4)
#  bond_ratio  :decimal(15, 4)
#  cash_ratio  :decimal(15, 4)
#  net_asset   :decimal(15, 4)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  origin      :integer          default("fund_zcpz"), not null
#

class AssetAllocation < ApplicationRecord
  belongs_to :project

  validates_presence_of :project_id
  validates_presence_of :record_at

  validates_uniqueness_of :record_at, scope: :project_id

  # 天天基金网的资产配置页、基金详情页
  enum origin: { fund_zcpz: 0, fund_show_page: 11 }
end
