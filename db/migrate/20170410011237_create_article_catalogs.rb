class CreateArticleCatalogs < ActiveRecord::Migration[5.0]
  def change
    create_table :article_catalogs do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
