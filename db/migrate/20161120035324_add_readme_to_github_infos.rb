class AddReadmeToGithubInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :github_infos, :readme, :text
  end
end
