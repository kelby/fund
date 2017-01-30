class AddMotherSonToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :mother_son, :integer, default: 0
  end
end
