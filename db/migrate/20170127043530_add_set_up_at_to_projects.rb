class AddSetUpAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :set_up_at, :date
  end
end
