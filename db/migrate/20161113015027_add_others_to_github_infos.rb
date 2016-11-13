class AddOthersToGithubInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :github_infos, :others, :text
    add_column :projects, :author, :text
  end
end
