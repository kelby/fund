class AddMoldToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :mold, :string
  end
end
