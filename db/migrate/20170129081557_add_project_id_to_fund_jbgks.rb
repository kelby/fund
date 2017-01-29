class AddProjectIdToFundJbgks < ActiveRecord::Migration[5.0]
  def change
    add_column :fund_jbgks, :project_id, :integer

    add_index :fund_jbgks, :project_id
  end
end
