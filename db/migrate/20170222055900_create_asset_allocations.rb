class CreateAssetAllocations < ActiveRecord::Migration[5.0]
  def change
    create_table :asset_allocations do |t|
      t.integer :project_id
      t.date :record_at
      t.decimal :stock_ratio, precision: 15, scale: 4
      t.decimal :bond_ratio, precision: 15, scale: 4
      t.decimal :cash_ratio, precision: 15, scale: 4
      t.decimal :net_asset, precision: 15, scale: 4

      t.timestamps
    end

    add_index :asset_allocations, :project_id
    add_index :asset_allocations, [:project_id, :record_at]
  end
end
