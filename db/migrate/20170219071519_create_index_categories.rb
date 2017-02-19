class CreateIndexCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :index_categories do |t|
      t.string :name
      t.string :website
      t.integer :index_catalog_id
      t.text :intro

      t.timestamps
    end

    add_index :index_categories, :name
    add_index :index_categories, :index_catalog_id
  end
end
