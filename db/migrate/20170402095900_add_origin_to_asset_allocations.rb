class AddOriginToAssetAllocations < ActiveRecord::Migration[5.0]
  def change
    add_column :asset_allocations, :origin, :integer, default: 0, null: false
  end
end
