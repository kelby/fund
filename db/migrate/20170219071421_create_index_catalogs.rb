class CreateIndexCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :index_catalogs do |t|
      t.string :name
      t.string :website

      t.timestamps
    end

    add_index :index_catalogs, :name
  end
end
