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

  serialize :info, Hash
  serialize :extra, Hash
  serialize :credentials, Hash

  def avatar_url
    _avatar_url = ""

    if self.info.present?
      begin
        json_info = JSON.parse(self.info)
        _avatar_url = json_info['image']
      rescue Exception => e
        # ...
      end
    end

    _avatar_url
  end
end
