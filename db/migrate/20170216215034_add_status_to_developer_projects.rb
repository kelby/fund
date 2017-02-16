class AddStatusToDeveloperProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :developer_projects, :status, :integer, default: 0

    DeveloperProject.reset_column_information

    # 有结束日期即为 offline
    DeveloperProject.where.not(end_of_work_date: nil).update_all(status: 1)
  end
end
