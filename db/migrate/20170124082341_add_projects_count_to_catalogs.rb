class AddProjectsCountToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :projects_count, :integer, null: false, default: 0
  end
end
