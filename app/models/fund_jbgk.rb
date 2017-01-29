# == Schema Information
#
# Table name: fund_jbgks
#
#  id                 :integer          not null, primary key
#  full_name          :string(255)
#  short_name         :string(255)
#  code               :string(255)
#  mold               :string(255)
#  set_up_at          :string(255)
#  build_at_and_scale :string(255)
#  assets_scale       :string(255)
#  portion_scale      :string(255)
#  benchmark          :text(65535)
#  dividend_policy    :text(65535)
#  risk_yield         :text(65535)
#  others             :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  project_id         :integer
#

class FundJbgk < ApplicationRecord
  # validates_uniqueness_of :code

  validates_presence_of :code, :full_name

  serialize :others, Hash

  belongs_to :project
end
