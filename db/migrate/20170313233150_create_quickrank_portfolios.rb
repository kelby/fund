class CreateQuickrankPortfolios < ActiveRecord::Migration[5.0]
  def change
    create_table :quickrank_portfolios do |t|
      t.date :rating_date
      t.integer :project_id
      t.string :project_code
      t.string :morningstar_code
      t.string :project_name
      t.integer :delivery_style
      t.decimal :stock_ratio, precision: 15, scale: 4
      t.decimal :bond_ratio, precision: 15, scale: 4
      t.decimal :top_ten_stock_ratio, precision: 15, scale: 4
      t.decimal :top_ten_bond_ratio, precision: 15, scale: 4
      t.decimal :net_asset, precision: 15, scale: 4

      t.timestamps
    end

    add_index :quickrank_portfolios, :project_id
    add_index :quickrank_portfolios, :project_code
    add_index :quickrank_portfolios, :morningstar_code
    add_index :quickrank_portfolios, :rating_date
    add_index :quickrank_portfolios, [:project_code, :rating_date]
  end
end
