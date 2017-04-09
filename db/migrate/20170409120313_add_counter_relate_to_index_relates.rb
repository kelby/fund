class AddCounterRelateToIndexRelates < ActiveRecord::Migration[5.0]
  def change
    add_column :index_catalogs, :slug, :string
    add_column :index_catalogs, :index_categories_count, :integer, default: 0, null: false
    add_column :index_catalogs, :index_reports_count, :integer, default: 0, null: false

    add_column :index_categories, :slug, :string
    add_column :index_categories, :index_reports_count, :integer, default: 0, null: false
    add_column :index_categories, :index_catalog_id, :integer

    add_column :index_reports, :index_catalog_id, :integer
    add_index  :index_reports, :index_catalog_id
    add_column :index_reports, :index_category_id, :integer
    add_index  :index_reports, :index_category_id


    IndexCatalog.reset_column_information
    IndexCategory.reset_column_information
    IndexReport.reset_column_information


    IndexCatalog.init_datas
    IndexCategory.init_datas
    IndexReport.init_parents_datas

    remove_index :index_reports, :catalog_slug
    remove_index :index_reports, :category_slug
    remove_index :index_reports, [:catalog_slug, :category_slug]

    remove_column :index_reports, :catalog
    remove_column :index_reports, :category
    remove_column :index_reports, :category_intro
    remove_column :index_reports, :catalog_slug
    remove_column :index_reports, :category_slug
  end
end
