class AddUserIdToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :user_id, :integer
    add_column :articles, :view_times, :integer, default: 0


    add_column :users, :username, :string


    add_index :articles, :user_id
  end
end
