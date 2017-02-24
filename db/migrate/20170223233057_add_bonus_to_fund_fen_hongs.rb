class AddBonusToFundFenHongs < ActiveRecord::Migration[5.0]
  def change
    add_column :fund_fen_hongs, :bonus, :decimal, precision: 15, scale: 4

    FundFenHong.reset_column_information

    FundFenHong.find_each do |ff|
      ff.bonus = ff.bonus_per.gsub(/^每份派现金/, "").gsub(/元$/, "").to_f
      ff.save
    end
  end
end
