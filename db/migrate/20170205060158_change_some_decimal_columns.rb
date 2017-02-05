class ChangeSomeDecimalColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :fund_rankings, :dwjz, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_week_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_month_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_three_month_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_six_month_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_year_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_two_year_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :this_year_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :since_the_inception_total_return, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_three_year_volatility, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_three_year_risk_factor, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_three_year_sharpe_ratio, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_one_year_volatility, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_one_year_risk_factor, :decimal, precision: 15, scale: 4
    change_column :fund_rankings, :last_one_year_sharpe_ratio, :decimal, precision: 15, scale: 4

    change_column :quotes, :price, :decimal, precision: 15, scale: 4
    change_column :quotes, :up_down_number, :decimal, precision: 15, scale: 4
    change_column :quotes, :max_up_number, :decimal, precision: 15, scale: 4
    change_column :quotes, :min_down_number, :decimal, precision: 15, scale: 4
    change_column :quotes, :open_number, :decimal, precision: 15, scale: 4
    change_column :quotes, :yesterday_close_number, :decimal, precision: 15, scale: 4
    change_column :quotes, :up_down_rate, :decimal, precision: 15, scale: 4
    change_column :quotes, :turnover, :decimal, precision: 15, scale: 4
    change_column :quotes, :volume_of_business, :decimal, precision: 15, scale: 4
  end
end
