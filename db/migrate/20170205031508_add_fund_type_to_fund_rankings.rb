class AddFundTypeToFundRankings < ActiveRecord::Migration[5.0]
  def change
    add_column :fund_rankings, :fund_type, :string
    add_column :fund_rankings, :evaluate_type, :string

    add_column :fund_rankings, :two_year_rating, :integer
    add_column :fund_rankings, :one_year_rating, :integer

    add_column :fund_rankings, :last_one_year_volatility            , :decimal
    add_column :fund_rankings, :last_one_year_volatility_evaluate   , :string
    add_column :fund_rankings, :last_one_year_risk_factor           , :decimal
    add_column :fund_rankings, :last_one_year_risk_factor_evaluate  , :string

    add_column :fund_rankings, :last_one_year_sharpe_ratio          , :decimal
    add_column :fund_rankings, :last_one_year_sharpe_ratio_evaluate , :string
  end
end
