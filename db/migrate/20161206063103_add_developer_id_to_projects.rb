class AddDeveloperIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :developer_id, :integer
  end
end
