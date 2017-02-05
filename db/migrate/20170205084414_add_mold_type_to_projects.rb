class AddMoldTypeToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :mold_type, :integer, default: 0
  end
end
