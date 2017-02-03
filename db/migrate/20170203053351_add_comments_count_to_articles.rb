class AddCommentsCountToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :comments_count, :integer, default: 0
    add_column :projects, :comments_count, :integer, default: 0

    add_column :articles, :slug, :string
  end
end
