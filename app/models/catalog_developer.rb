class CatalogDeveloper < ApplicationRecord
  belongs_to :catalog
  belongs_to :developer


  validates_uniqueness_of :catalog_id, scope: :developer_id
end
