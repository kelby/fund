class CreateUserStarProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :user_star_projects do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
