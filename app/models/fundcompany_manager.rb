# == Schema Information
#
# Table name: fundcompany_managers
#
#  id                       :integer          not null, primary key
#  fundcompany_id           :integer
#  name                     :string(255)
#  managers_count           :integer
#  scale_manager_avg        :decimal(10, )
#  tenure_avg               :string(255)
#  three_years_tenure_count :integer
#  retention_rate           :decimal(10, )
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class FundcompanyManager < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
end
