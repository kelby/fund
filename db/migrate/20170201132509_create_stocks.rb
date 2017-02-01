class CreateStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :code
      t.string :catalog

      t.timestamps
    end

    add_index :stocks, :code

    add_column :quotes, :stock_id, :integer
    add_index :quotes, [:stock_id, :record_at]
  end
end
