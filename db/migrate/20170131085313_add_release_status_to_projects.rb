class AddReleaseStatusToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :release_status, :integer, default: 0
  end
end
