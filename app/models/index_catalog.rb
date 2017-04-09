# == Schema Information
#
# Table name: index_catalogs
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  website                :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string(255)
#  index_categories_count :integer          default(0), not null
#  index_reports_count    :integer          default(0), not null
#

class IndexCatalog < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :index_categories
  has_many :index_reports

  scope :with_data, -> { where.not(slug: nil) }

  def self.init_datas
    ::IndexReport.pluck(:catalog).uniq.each do |name|
      self.create(name: name, slug: ::IndexReport::CATALOG_HASH.select{|key, value| name.match(value) }.keys[0])
    end
  end
end
