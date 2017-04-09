# == Schema Information
#
# Table name: index_categories
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  website             :string(255)
#  index_catalog_id    :integer
#  intro               :text(65535)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  slug                :string(255)
#  index_reports_count :integer          default(0), not null
#

class IndexCategory < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :index_reports
  belongs_to :index_catalog

  scope :with_data, -> { where.not(slug: nil) }

  def self.init_datas
    ::IndexReport.pluck(:category).uniq.each do |name|
      report = ::IndexReport.find_by(category: name)

      category = ::IndexCategory.create(name: name, slug: Pinyin.t(name, splitter: '-').parameterize)

      category.index_catalog_id = IndexCatalog.find_by(slug: report[:catalog_slug]).id
      category.intro = report[:category_intro]

      category.save
    end
  end
end
