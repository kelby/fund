# == Schema Information
#
# Table name: authentications
#
#  id            :integer          not null, primary key
#  provider      :string(191)
#  uid           :string(191)
#  user_id       :integer
#  info          :text(65535)
#  extra         :text(65535)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  refresh_token :string(191)
#

class Authentication < ApplicationRecord
  belongs_to :user

  validates_presence_of :provider
  validates_presence_of :uid

  validates_uniqueness_of :uid, scope: :provider
end
