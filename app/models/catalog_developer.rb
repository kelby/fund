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
#

class CatalogDeveloper < ApplicationRecord
  belongs_to :catalog
  belongs_to :developer


  validates_uniqueness_of :catalog_id, scope: :developer_id
end
