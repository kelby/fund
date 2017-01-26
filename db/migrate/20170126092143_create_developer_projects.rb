class CreateDeveloperProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :developer_projects do |t|
      t.integer :developer_id
      t.integer :project_id
      t.date :beginning_work_date
      t.date :end_of_work_date

      t.timestamps
    end

    add_index :developer_projects, [:developer_id, :project_id]
  end
end
