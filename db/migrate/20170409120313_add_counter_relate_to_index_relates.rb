class AddCounterRelateToIndexRelates < ActiveRecord::Migration[5.0]
  def change
    unless column_exists?(:index_catalogs, :slug)
      add_column :index_catalogs, :slug, :string
    end
    unless column_exists?(:index_catalogs, :index_categories_count)
      add_column :index_catalogs, :index_categories_count, :integer, default: 0, null: false
    end
    unless column_exists?(:index_catalogs, :index_reports_count)
      add_column :index_catalogs, :index_reports_count, :integer, default: 0, null: false
    end

    unless column_exists?(:index_categories, :slug)
      add_column :index_categories, :slug, :string
    end
    unless column_exists?(:index_categories, :index_reports_count)
      add_column :index_categories, :index_reports_count, :integer, default: 0, null: false
    end
    unless column_exists?(:index_categories, :index_catalog_id)
      add_column :index_categories, :index_catalog_id, :integer
    end

    unless column_exists?(:index_reports, :index_catalog_id)
      add_column :index_reports, :index_catalog_id, :integer
    end
    unless index_exists?(:index_reports, :index_catalog_id)
      add_index  :index_reports, :index_catalog_id
    end
    unless column_exists?(:index_reports, :index_category_id)
      add_column :index_reports, :index_category_id, :integer
    end
    unless index_exists?(:index_reports, :index_category_id)
      add_index  :index_reports, :index_category_id
    end


    IndexCatalog.reset_column_information
    IndexCategory.reset_column_information
    IndexReport.reset_column_information


    IndexCatalog.init_datas
    IndexCategory.init_datas
    IndexReport.init_parents_datas

    if index_exists? :index_reports, :catalog_slug
      remove_index :index_reports, :catalog_slug
    end
    if index_exists? :index_reports, :category_slug
      remove_index :index_reports, :category_slug
    end
    if index_exists? :index_reports, [:catalog_slug, :category_slug]
      remove_index :index_reports, [:catalog_slug, :category_slug]
    end

    if column_exists? :index_reports, :catalog
      remove_column :index_reports, :catalog
    end
    if column_exists? :index_reports, :category
      remove_column :index_reports, :category
    end
    if column_exists? :index_reports, :category_intro
      remove_column :index_reports, :category_intro
    end
    if column_exists? :index_reports, :catalog_slug
      remove_column :index_reports, :catalog_slug
    end
    if column_exists? :index_reports, :category_slug
      remove_column :index_reports, :category_slug
    end

    # IndexCatalog.reset_column_information
    # IndexCategory.reset_column_information
    # IndexReport.reset_column_information

    # ::IndexCatalog.with_data.find_each do |catalog|
    #   ::IndexCatalog.reset_counters(catalog.id, :index_categories)
    #   ::IndexCatalog.reset_counters(catalog.id, :index_reports)
    # end

    # ::IndexCategory.with_data.find_each do |category|
    #   ::IndexCategory.reset_counters(category.id, :index_reports)
    # end
  end
end
