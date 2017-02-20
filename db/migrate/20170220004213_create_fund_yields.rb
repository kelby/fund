class CreateFundYields < ActiveRecord::Migration[5.0]
  def change
    create_table :fund_yields do |t|
      t.integer :project_id

      t.date :beginning_day
      t.date :end_day

      t.decimal :beginning_net_worth, precision: 15, scale: 4
      t.decimal :end_net_worth, precision: 15, scale: 4

      t.integer :fund_chai_fens_count, default: 0
      t.integer :fund_fen_hongs, default: 0

      t.integer :yield_type, default: 0

      t.decimal :yield_rate, precision: 15, scale: 4

      t.timestamps
    end
  end
end
