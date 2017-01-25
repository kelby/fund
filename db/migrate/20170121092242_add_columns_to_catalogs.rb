class AddColumnsToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :initial, :integer, default: 0
    add_column :catalogs, :short_name, :string
    add_column :catalogs, :founder, :string
    add_column :catalogs, :set_up_at, :date
    add_column :catalogs, :scale, :string
    add_column :catalogs, :scale_record_at, :date
  end
end
