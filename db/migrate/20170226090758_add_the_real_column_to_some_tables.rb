class AddTheRealColumnToSomeTables < ActiveRecord::Migration[5.0]
  def change
    add_column :fund_fen_hongs, :the_real_ex_dividend_at, :date
    add_column :fund_chai_fens, :the_real_break_convert_at, :date

    FundFenHong.reset_column_information
    FundChaiFen.reset_column_information

    FundFenHong.find_each do |ffh|
      ffh.set_the_real_ex_dividend_at
    end

    FundChaiFen.find_each do |fcf|
      fcf.set_the_real_break_convert_at
    end
  end
end
