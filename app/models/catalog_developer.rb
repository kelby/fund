# == Schema Information
#
# Table name: catalog_developers
#
#  id           :integer          not null, primary key
#  catalog_id   :integer
#  developer_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CatalogDeveloper < ApplicationRecord
  belongs_to :catalog
  belongs_to :developer


  validates_uniqueness_of :catalog_id, scope: :developer_id
end
