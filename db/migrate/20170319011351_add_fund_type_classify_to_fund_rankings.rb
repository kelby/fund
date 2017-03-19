class AddFundTypeClassifyToFundRankings < ActiveRecord::Migration[5.0]
  def change
    add_column :fund_rankings, :fund_type_classify, :integer, default: 0

    add_index :fund_rankings, :fund_type_classify
    add_index :fund_rankings, [:record_at, :fund_type_classify]

    # FundRanking.reset_column_information

    # FundRanking.fund_type_unknow.find_each do |fr|
    #   type_method = Pinyin.t(fr.format_fund_type, splitter: "_").downcase

    #   if FundRanking.fund_type_classifies.keys.include?(type_method)
    #     new_method = "#{type_method}!"
    #     fr.send(new_method)
    #   else
    #     # fr.fund_type_unknow!
    #   end
    # end
  end
end
