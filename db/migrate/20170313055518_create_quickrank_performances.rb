class CreateQuickrankPerformances < ActiveRecord::Migration[5.0]
  def change
    create_table :quickrank_performances do |t|
      t.date :rating_date
      t.integer :project_id
      t.string :project_code
      t.string :morningstar_code
      t.string :project_name
      t.decimal :last_day_total_return, precision: 15, scale: 4
      t.decimal :last_week_total_return, precision: 15, scale: 4
      t.decimal :last_month_total_return, precision: 15, scale: 4
      t.decimal :last_three_month_total_return, precision: 15, scale: 4
      t.decimal :last_six_month_total_return, precision: 15, scale: 4
      t.decimal :last_year_total_return, precision: 15, scale: 4
      t.decimal :last_two_year_total_return, precision: 15, scale: 4
      t.decimal :last_three_year_total_return, precision: 15, scale: 4
      t.decimal :last_five_year_total_return, precision: 15, scale: 4
      t.decimal :last_ten_year_total_return, precision: 15, scale: 4
      t.decimal :since_the_inception_total_return, precision: 15, scale: 4
      t.decimal :three_year_volatility, precision: 15, scale: 4
      t.decimal :three_year_risk_factor, precision: 15, scale: 4

      t.timestamps
    end

    add_index :quickrank_performances, :project_id
    add_index :quickrank_performances, :project_code
    add_index :quickrank_performances, :morningstar_code
    add_index :quickrank_performances, :rating_date
    add_index :quickrank_performances, [:project_code, :rating_date]
  end
end
