class AddOnlineProjectsCountToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :online_projects_count, :integer, default: 0, null: false

    Category.reset_column_information

    Project.counter_culture_fix_counts
  end
end
