class AddCountToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :categories_count, :integer, default: 0
    add_column :categories, :projects_count, :integer, default: 0
  end
end
