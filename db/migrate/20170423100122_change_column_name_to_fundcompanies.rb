class ChangeColumnNameToFundcompanies < ActiveRecord::Migration[5.0]
  def change
    rename_column :fundcompanies, :project_id, :catalog_id

    if index_exists?(:fundcompanies, :project_id)
      remove_index :fundcompanies, :project_id
    end

    unless index_exists?(:fundcompanies, :catalog_id)
      add_index :fundcompanies, :catalog_id
    end
  end
end
