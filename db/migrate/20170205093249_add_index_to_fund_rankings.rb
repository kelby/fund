class AddIndexToFundRankings < ActiveRecord::Migration[5.0]
  def change
    add_index :fund_rankings, [:record_at, :code]
  end
end
