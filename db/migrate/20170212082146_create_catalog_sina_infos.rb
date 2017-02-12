class CreateCatalogSinaInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :catalog_sina_infos do |t|
      t.integer :catalog_id
      t.string :catalog_sina_code
      t.text :header_info
      t.text :body_info
      t.text :table_info
      t.text :other_info

      t.timestamps
    end
  end
end
