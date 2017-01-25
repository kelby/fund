class AddCodeAndCatalogIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :code, :string
    add_column :projects, :catalog_id, :integer

    add_column :catalogs, :raw_show_html, :text
  end
end
