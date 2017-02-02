class CreateFundRankings < ActiveRecord::Migration[5.0]
  def change
    create_table :fund_rankings do |t|
      t.integer :project_id
      t.string :code
      t.string :name
      t.decimal :dwjz
      t.integer :three_year_rating
      t.integer :five_year_rating
      t.decimal :last_week_total_return
      t.integer :last_week_ranking
      t.decimal :last_month_total_return
      t.integer :last_month_ranking
      t.decimal :last_three_month_total_return
      t.integer :last_three_month_ranking
      t.decimal :last_six_month_total_return
      t.integer :last_six_month_ranking
      t.decimal :last_year_total_return
      t.integer :last_year_ranking
      t.decimal :last_two_year_total_return
      t.integer :last_two_year_ranking
      t.decimal :this_year_total_return
      t.integer :this_year_ranking
      t.decimal :since_the_inception_total_return
      t.decimal :last_three_year_volatility
      t.string :last_three_year_volatility_evaluate
      t.decimal :last_three_year_risk_factor
      t.string :last_three_year_risk_factor_evaluate
      t.decimal :last_three_year_sharpe_ratio
      t.string :last_three_year_sharpe_ratio_evaluate

      t.date :record_at

      t.timestamps
    end

    add_index :fund_rankings, [:project_id, :record_at]
  end
end
