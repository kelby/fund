class CreateCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :catalogs do |t|
      t.string :name
      t.string :slug
      t.string :type

      t.timestamps
    end
  end
end
