class ChangeFundFenHongsToFundYields < ActiveRecord::Migration[5.0]
  def change
    rename_column :fund_yields, :fund_fen_hongs, :fund_fen_hongs_count
  end
end
