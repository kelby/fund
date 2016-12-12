# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  slug           :string(255)
#  catalog_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  projects_count :integer          default(0)
#

class Category < ApplicationRecord
  belongs_to :catalog, counter_cache: true

  has_many :projects

  before_create :set_slug

  def self.set_categories
    ["Active Record DB Adapters",
    "Active Record Default Values",
    "Active Record Enumerations",
    "Active Record Index Assistants",
    "Active Record Named Scopes",
    "Active Record Nesting",
    "Active Record Sharding",
    "Active Record Soft Delete",
    "Active Record Sortables",
    "Active Record User Stamping",
    "Active Record Value Cleanup",
    "Active Record Versioning",
    "Pagination",
    "Rails Comments",
    "Rails DB Bootstrapping",
    "Rails Ratings",
    "Rails Search",
    "Rails Tagging"].each do |category|
      next if category.blank?
      catalog = Catalog.find_by(name: "Active Record Plugins")

      next if catalog.blank?

      catalog.categories.create(name: category,
        slug: Pinyin.t(category, splitter: "_"))
    end

    ["Background Jobs",
    "Daemonizing",
    "Daemon Management",
    "Scheduling"].each do |category|
      next if category.blank?
      catalog = Catalog.find_by(name: "Background Processing")

      next if catalog.blank?

      catalog.categories.create(name: category,
        slug: Pinyin.t(category, splitter: "_"))
    end
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '_')
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end
end
