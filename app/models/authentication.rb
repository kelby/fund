# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  info       :text(65535)
#  extra      :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authentication < ApplicationRecord
  belongs_to :user

  validates_presence_of :provider
  validates_presence_of :uid

  validates_uniqueness_of :uid, scope: :provider
end
