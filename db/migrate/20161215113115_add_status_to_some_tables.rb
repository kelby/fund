class AddStatusToSomeTables < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :status, :integer, default: 0
    add_column :categories, :status, :integer, default: 0
  end
end
