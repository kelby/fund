class CreateFundcompanyAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompany_assets do |t|
      t.integer :fundcompany_id
      t.string :name
      t.decimal :scale
      t.decimal :stock
      t.decimal :bond
      t.decimal :cash
      t.decimal :other

      t.timestamps
    end
    add_index :fundcompany_assets, :fundcompany_id
  end
end
