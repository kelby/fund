class AddPopularityToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :popularity, :decimal, precision: 15, scale: 2
  end
end
