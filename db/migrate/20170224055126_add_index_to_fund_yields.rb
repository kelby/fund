class AddIndexToFundYields < ActiveRecord::Migration[5.0]
  def change
    add_index :fund_yields, :project_id
    add_index :fund_yields, [:project_id, :yield_type]
  end
end
