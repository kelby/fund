class Package < ApplicationRecord
  belongs_to :category

  has_many :projects

  def self.set_packages
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
    "Rails Tagging"].each do |package|
      next if package.blank?
      category = Category.find_by(name: "Active Record Plugins")

      next if category.blank?

      category.packages.create(name: package,
        slug: Pinyin.t(package, splitter: "_"))
    end

    ["Background Jobs",
    "Daemonizing",
    "Daemon Management",
    "Scheduling"].each do |package|
      next if package.blank?
      category = Category.find_by(name: "Background Processing")

      next if category.blank?

      category.packages.create(name: package,
        slug: Pinyin.t(package, splitter: "_"))
    end
  end
end
