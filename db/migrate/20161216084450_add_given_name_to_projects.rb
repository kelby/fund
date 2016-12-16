class AddGivenNameToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :given_name, :string
  end
end
