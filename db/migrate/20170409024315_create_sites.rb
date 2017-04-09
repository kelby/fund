class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :title
      t.string :slug
      t.text :description

      t.timestamps
    end

    add_index :sites, :slug
  end
end
