# == Schema Information
#
# Table name: fundcompany_infos
#
#  id             :integer          not null, primary key
#  fundcompany_id :integer
#  name           :string(255)
#  city           :string(255)
#  address        :string(255)
#  zip_code       :string(255)
#  telphone       :string(255)
#  website        :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class FundcompanyInfo < ApplicationRecord
end
