class CreateFundFenHongs < ActiveRecord::Migration[5.0]
  def change
    create_table :fund_fen_hongs do |t|
      t.date :register_at
      t.date :ex_dividend_at
      t.string :bonus_per
      t.date :dividend_distribution_at
      t.integer :project_id
      t.integer :net_worth_id

      t.timestamps
    end
  end
end
