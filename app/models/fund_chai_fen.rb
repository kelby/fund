# == Schema Information
#
# Table name: fund_chai_fens
#
#  id               :integer          not null, primary key
#  break_convert_at :date
#  break_type       :string(255)
#  break_ratio      :string(255)
#  project_id       :integer
#  net_worth_id     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class FundChaiFen < ApplicationRecord
  validates_presence_of :net_worth_id
  validates_presence_of :break_convert_at, :break_type, :break_ratio

  validates_uniqueness_of :net_worth_id


  belongs_to :project
  belongs_to :net_worth
end
