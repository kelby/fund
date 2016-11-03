class CreatePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :slug
      t.integer :category_id

      t.timestamps
    end
  end
end
