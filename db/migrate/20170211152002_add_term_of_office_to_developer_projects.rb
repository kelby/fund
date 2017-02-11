class AddTermOfOfficeToDeveloperProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :developer_projects, :term_of_office, :string
    add_column :developer_projects, :as_return, :decimal, precision: 15, scale: 4
  end
end
