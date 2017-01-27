class AddSomeIndexToNetWorths < ActiveRecord::Migration[5.0]
  def change
    add_index :net_worths, :project_id
    add_index :net_worths, [:project_id, :record_at]
  end
end
