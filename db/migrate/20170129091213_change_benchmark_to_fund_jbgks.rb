class ChangeBenchmarkToFundJbgks < ActiveRecord::Migration[5.0]
  def change
    change_column :fund_jbgks, :benchmark, :text
  end
end
