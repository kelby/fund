class Authentication < ApplicationRecord
  belongs_to :user

  validates_presence_of :provider
  validates_presence_of :uid

  validates_uniqueness_of :uid, scope: :provider
end
