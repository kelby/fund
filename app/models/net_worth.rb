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
#  status     :integer          default(0)
#

# iopv 日增长值, accnav 日增长率
# dwjz 单位净值, ljjz 累计净值
class NetWorth < ApplicationRecord
  # Associations
  belongs_to :project

  has_many :fund_chai_fens
  has_many :fund_fen_hongs
  # END


  # Validates
  validates_presence_of :project_id
  validates_presence_of :record_at

  validates_uniqueness_of :record_at, scope: :project_id
  # END


  # Rails class methods
  enum source_type: { source_normal: 0, source_fen_hong: 2, source_chai_fen: 4 }
  # END


  def accnav_color
    if self.accnav > 0
      'red'
    elsif self.accnav < 0
      'green'
    else
      # ...
    end
  end
end
