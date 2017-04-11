class AddTopAtToArticleCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :article_categories, :top_at, :datetime
  end
end
