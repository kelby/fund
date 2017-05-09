class AddSomeColumnsToFundcompanyBestReturns < ActiveRecord::Migration[5.0]
  def change
    add_column :fundcompany_best_returns, :return_inception_fund, :string
    add_column :fundcompany_best_returns, :three_year_return_inception_fund, :string
    add_column :fundcompany_best_returns, :this_year_return_inception_fund, :string

    change_column :fundcompany_best_returns, :return_inception, :decimal, precision: 15, scale: 4
    change_column :fundcompany_best_returns, :three_year_return_inception, :decimal, precision: 15, scale: 4
    change_column :fundcompany_best_returns, :this_year_return_inception, :decimal, precision: 15, scale: 4
  end
end
