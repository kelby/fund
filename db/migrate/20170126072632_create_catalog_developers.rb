class CreateCatalogDevelopers < ActiveRecord::Migration[5.0]
  def change
    create_table :catalog_developers do |t|
      t.integer :catalog_id
      t.integer :developer_id

      t.string :eastmoney_url
      t.string :sina_url

      t.timestamps
    end

    add_index :catalog_developers, [:catalog_id, :developer_id]
  end
end
