class AddTodayRecommendAndRecommendAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :today_recommend, :boolean
    add_column :projects, :recommend_at, :datetime
  end
end
