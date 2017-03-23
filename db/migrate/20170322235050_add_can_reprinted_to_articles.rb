class AddCanReprintedToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :can_reprinted, :boolean, default: true
  end
end
