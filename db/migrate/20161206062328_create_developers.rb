class CreateDevelopers < ActiveRecord::Migration[5.0]
  def change
    create_table :developers do |t|
      t.string :name
      t.string :avatar
      t.integer :github_id
      t.integer :public_repos
      t.integer :subscribers_count
      t.integer :watchers_count
      t.integer :forks_count
      t.integer :identity, default: 0

      t.timestamps
    end
  end
end
