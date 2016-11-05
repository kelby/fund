class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :wiki
      t.string :source_code
      t.integer :category_id

      t.timestamps
    end
  end
end
