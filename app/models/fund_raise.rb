# == Schema Information
#
# Table name: fund_raises
#
#  id           :integer          not null, primary key
#  project_id   :integer
#  beginning_at :date
#  endding_at   :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FundRaise < ApplicationRecord
  belongs_to :project

  validates_presence_of :project_id
  validates_presence_of :beginning_at, :endding_at

  validates_uniqueness_of :project_id #, scope: [:beginning_at, :endding_at]
end
