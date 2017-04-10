class CreateArticleCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :article_categories do |t|
      t.string :name
      t.string :slug
      t.string :cover
      t.string :intro
      t.integer :article_catalog_id

      t.timestamps
    end
  end
end
