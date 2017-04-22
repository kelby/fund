class CreateFundcompanySnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompany_snapshots do |t|
      t.integer :fundcompany_id
      t.string :name
      t.string :city
      t.date :set_up_at
      t.decimal :scale
      t.integer :funds_count
      t.integer :managers_count
      t.string :tenure_avg
      t.integer :this_year_best_fund_id
      t.decimal :this_year_best_fund_total_return

      t.timestamps
    end

    add_index :fundcompany_snapshots, :fundcompany_id
  end
end
