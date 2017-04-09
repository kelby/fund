class AddCategorySlugAndCategoryCnToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :index_reports, :catalog_slug, :string
    add_column :index_reports, :category_slug, :string

    add_index :index_reports, :catalog_slug
    add_index :index_reports, :category_slug
    add_index :index_reports, [:catalog_slug, :category_slug]
  end
end
