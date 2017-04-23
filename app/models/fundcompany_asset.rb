# == Schema Information
#
# Table name: fundcompany_assets
#
#  id             :integer          not null, primary key
#  fundcompany_id :integer
#  name           :string(255)
#  scale          :decimal(10, )
#  stock          :decimal(10, )
#  bond           :decimal(10, )
#  cash           :decimal(10, )
#  other          :decimal(10, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class FundcompanyAsset < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
end
