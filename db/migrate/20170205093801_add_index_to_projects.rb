class AddIndexToProjects < ActiveRecord::Migration[5.0]
  def change
    add_index :projects, :code
  end
end
