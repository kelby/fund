class AddCatalogCodeToCatalogDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :catalog_developers, :catalog_code, :string
    add_column :catalog_developers, :developer_eastmoney_code, :string
    add_column :catalog_developers, :developer_sina_code, :string
  end
end
