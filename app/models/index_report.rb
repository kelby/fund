# == Schema Information
#
# Table name: index_reports
#
#  id                :integer          not null, primary key
#  catalog           :string(255)
#  category          :string(255)
#  category_intro    :string(255)
#  name              :string(255)
#  intro             :text(16777215)
#  website           :string(255)
#  code              :string(255)
#  set_up_at         :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  slug              :string(255)
#  catalog_slug      :string(255)
#  category_slug     :string(255)
#  index_catalog_id  :integer
#  index_category_id :integer
#

class IndexReport < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :website

  before_create :set_slug
  before_create :set_catalog_category_slug

  belongs_to :index_catalog
  belongs_to :index_category

  delegate :name, to: :index_catalog, prefix: :catalog
  delegate :slug, to: :index_catalog, prefix: :catalog
  delegate :name, to: :index_category, prefix: :category
  delegate :slug, to: :index_category, prefix: :category
  delegate :intro, to: :index_category, prefix: :category

  CATALOG_HASH = {"zhong-zheng" => "中证系列指数",
    "shang-zheng" => "上证系列指数",
    "zhong-hua-jiao-yi" => "中华交易服务系列指数",
    "shen-zheng" => "深证系列指数",
    "san-ban" => "三板系列指数"}

  scope :has_catalog_category, -> { where.not(catalog_slug: nil, category_slug: nil) }

  def self.category_cn_array(catalog_en)
    # @category_cn_array = self.where(catalog_slug: catalog_en).pluck(:category)
    catalog = ::IndexCatalog.find_by(slug: catalog_en)
    catalog.index_categories.pluck(:name)
  end

  def self.category_en_array(catalog_en)
    category_cn_array(catalog_en).map{|category| Pinyin.t(category, splitter: '-').parameterize }
  end

  def self.category_hash_under(catalog_en)
    Hash[category_en_array(catalog_en).zip category_cn_array(catalog_en)]
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '')
  end

  def set_catalog_slug
    self.catalog_slug = ::IndexReport::CATALOG_HASH.select{|key, value| self.catalog.match(value) }.keys[0]
  end

  def set_category_slug
    self.category_slug = Pinyin.t(category, splitter: '-').parameterize
  end

  def to_param
    "#{self.code}-#{self.slug}"
  end

  def self.init_parents_datas
    self.all.find_each do |index_report|
      index_report.index_catalog_id = ::IndexCatalog.find_by(slug: index_report[:catalog_slug]).id
      index_report.index_category_id = ::IndexCategory.find_by(slug: index_report[:category_slug]).id

      index_report.save
    end
  end
end
