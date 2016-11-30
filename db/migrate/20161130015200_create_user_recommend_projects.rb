class CreateUserRecommendProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :user_recommend_projects do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
