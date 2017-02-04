class AddStatusToNetWorths < ActiveRecord::Migration[5.0]
  def change
    add_column :net_worths, :status, :integer, default: 0
  end
end
