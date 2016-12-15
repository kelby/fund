class AddHumanNameToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :human_name, :string
  end
end
