# == Schema Information
#
# Table name: fundcompany_performances
#
#  id                      :integer          not null, primary key
#  fundcompany_id          :integer
#  name                    :string(255)
#  rank_pre_one_four       :integer
#  rank_pre_one_two        :integer
#  rank_post_one_four      :integer
#  rank_post_one_two       :integer
#  return_lt_zero          :integer
#  return_zero_to_ten      :integer
#  return_ten_to_twenty    :integer
#  return_twenty_to_thirty :integer
#  return_thirty_to_fifty  :integer
#  return_gt_fifty         :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class FundcompanyPerformance < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
end
