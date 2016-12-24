class AddViewTimesToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :view_times, :integer, default: 0
  end
end
