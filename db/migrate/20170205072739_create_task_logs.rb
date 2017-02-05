class CreateTaskLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :task_logs do |t|
      t.string :key
      t.string :level
      t.text :content
      t.text :ext_info

      t.timestamps
    end
  end
end
