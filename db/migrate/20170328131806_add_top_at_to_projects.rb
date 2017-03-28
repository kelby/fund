class AddTopAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :top_at, :datetime
  end
end
