# == Schema Information
#
# Table name: net_worths
#
#  id         :integer          not null, primary key
#  iopv       :decimal(15, 4)
#  dwjz       :decimal(15, 4)
#  accnav     :decimal(15, 4)
#  ljjz       :decimal(15, 4)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer
#  record_at  :date
#

# iopv 日增长值, accnav 日增长率
# dwjz 单位净值, ljjz 累计净值
class NetWorth < ApplicationRecord
  belongs_to :project

  validates_presence_of :project_id
  validates_presence_of :record_at

  validates_uniqueness_of :record_at, scope: :project_id
end
