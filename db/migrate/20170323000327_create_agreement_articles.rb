class CreateAgreementArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :agreement_articles do |t|
      t.integer :user_id
      t.integer :article_id

      t.timestamps
    end

    add_index :agreement_articles, [:user_id, :article_id]

    add_column :articles, :agreement_articles_count, :integer, default: 0, null: false
  end
end
