class CreateUserFavorComments < ActiveRecord::Migration[5.0]
  def change
    create_table :user_favor_comments do |t|
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end

    add_index :user_favor_comments, [:user_id, :comment_id]
  end
end
