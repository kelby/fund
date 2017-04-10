class AddCategoryIdAndIndexToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :article_category_id, :integer
    add_column :article_categories, :articles_count, :integer, default: 0, null: false

    add_index :articles, :article_category_id
    add_index :article_categories, :article_catalog_id
  end
end
