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
  # Associations
  belongs_to :catalog #, counter_cache: true
  counter_culture :catalog
  counter_culture :catalog, :column_name => proc {|model| model.online? ? 'online_categories_count' : nil }

  has_many :projects
  # END


  # Callbacks
  before_create :set_slug
  # END

  # Rails class methods
  enum status: { online: 0, offline: 11, reviewed: 22}
  # END

  def self.no_online_projects_so_offline
    Category.where(online_projects_count: 0).update_all(status: Category.statuses['offline'])
  end

  def self.nil_catalog_so_offline
    Category.where(catalog_id: nil).update_all(status: Category.statuses['offline'])
  end

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

  def self.delay_get_projects(category_id)
    category = Category.find(category_id)

    category_name = category.slug
    category_name_downcase = category.slug.try(:downcase)

    url = "https://www.ruby-toolbox.com/categories/#{category_name}"
    url_downcase = "https://www.ruby-toolbox.com/categories/#{category_name_downcase}"

    unless url == url_downcase
      delay = rand(1..3600)
      self.delay_for(delay).ruby_toolbox(url_downcase, category.id)
    end

    delay = rand(1..3600)
    self.delay_for(delay).ruby_toolbox(url, category.id)
  end

  def self.ruby_toolbox(url, category_id)
    doc = ::Nokogiri::HTML(` curl "#{url}" `)

    if doc.present?
      source_codes = doc.css("a.source_code")

      return if source_codes.blank?

      source_codes.each do |source_code|
        github_url = source_code.attributes['href'].value

        if github_url =~ /github\.com/
          delay = rand(1..3600)
          Project.delay_for(delay).get_and_create_gem_project_from(github_url, category_id)
        end
      end
    end
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '_')
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end

  def full_name
    "#{self.catalog.try(:type)} - #{self.catalog.try(:name)} - #{self.name}"
  end

  def self.detect_and_set_online
    self.joins(:catalog).offline.where("categories.online_projects_count > ?", 0).update_all(status: Category.statuses['online'])
  end
end
