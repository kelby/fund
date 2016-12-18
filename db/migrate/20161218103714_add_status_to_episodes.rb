class AddStatusToEpisodes < ActiveRecord::Migration[5.0]
  def change
    add_column :episodes, :status, :integer, default: 0
  end
end
