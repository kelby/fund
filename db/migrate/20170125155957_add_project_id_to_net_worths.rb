class AddProjectIdToNetWorths < ActiveRecord::Migration[5.0]
  def change
    add_column :net_worths, :project_id, :integer
    add_column :net_worths, :record_at, :date
  end
end
