# == Schema Information
#
# Table name: catalog_sina_infos
#
#  id                :integer          not null, primary key
#  catalog_id        :integer
#  catalog_sina_code :string(255)
#  header_info       :text(65535)
#  body_info         :text(65535)
#  table_info        :text(65535)
#  other_info        :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class CatalogSinaInfo < ApplicationRecord
  belongs_to :catalog


  validates_presence_of :catalog_id
  validates_presence_of :catalog_sina_code

  validates_uniqueness_of :catalog_id
  validates_uniqueness_of :catalog_sina_code


  serialize :header_info, Hash
  serialize :body_info, Hash
  serialize :table_info, Hash
end
