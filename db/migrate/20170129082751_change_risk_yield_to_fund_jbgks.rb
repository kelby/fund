class ChangeRiskYieldToFundJbgks < ActiveRecord::Migration[5.0]
  def change
    change_column :fund_jbgks, :risk_yield, :text
  end
end
