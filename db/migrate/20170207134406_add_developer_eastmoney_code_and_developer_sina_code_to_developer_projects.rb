class AddDeveloperEastmoneyCodeAndDeveloperSinaCodeToDeveloperProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :developer_projects, :developer_eastmoney_code, :string
    add_column :developer_projects, :developer_sina_code, :string
    add_column :developer_projects, :project_code, :string
  end
end
