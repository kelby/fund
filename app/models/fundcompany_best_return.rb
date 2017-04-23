# == Schema Information
#
# Table name: fundcompany_best_returns
#
#  id                             :integer          not null, primary key
#  fundcompany_id                 :integer
#  name                           :string(255)
#  return_inception_id            :integer
#  return_inception               :decimal(10, )
#  three_year_return_inception_id :integer
#  three_year_return_inception    :decimal(10, )
#  this_year_return_inception_id  :integer
#  this_year_return_inception     :decimal(10, )
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class FundcompanyBestReturn < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
end
