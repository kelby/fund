class AddStatusToCatalogDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :catalog_developers, :status, :integer, default: 0
  end
end
