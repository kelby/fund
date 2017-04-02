# == Schema Information
#
# Table name: catalog_developers
#
#  id                       :integer          not null, primary key
#  catalog_id               :integer
#  developer_id             :integer
#  eastmoney_url            :string(255)
#  sina_url                 :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  catalog_code             :string(255)
#  developer_eastmoney_code :string(255)
#  developer_sina_code      :string(255)
#  status                   :integer          default("online")
#

class CatalogDeveloper < ApplicationRecord
  belongs_to :catalog
  belongs_to :developer


  validates_uniqueness_of :catalog_id, scope: :developer_id

  enum status: { online: 0, offline: 1 }

  STATUS_HASH = {'online' => "在任", 'offline' => "离任"}
end
