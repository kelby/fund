# == Schema Information
#
# Table name: fundcompany_stars
#
#  id               :integer          not null, primary key
#  fundcompany_id   :integer
#  name             :string(255)
#  funds_count      :integer
#  five_star_count  :integer
#  four_star_count  :integer
#  three_star_count :integer
#  two_star_count   :integer
#  one_star_count   :integer
#  none_star_count  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class FundcompanyStar < ApplicationRecord
end
