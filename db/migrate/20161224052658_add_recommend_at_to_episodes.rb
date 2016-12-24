class AddRecommendAtToEpisodes < ActiveRecord::Migration[5.0]
  def change
    add_column :episodes, :recommend_at, :datetime
  end
end
