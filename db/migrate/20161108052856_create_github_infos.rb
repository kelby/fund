class CreateGithubInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :github_infos do |t|
      t.integer :project_id
      t.integer :subscribers_count
      t.integer :watchers_count
      t.integer :forks_count

      t.timestamps
    end
  end
end
