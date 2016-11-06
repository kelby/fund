class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id
      t.text :info
      t.text :extra

      t.timestamps
    end
  end
end
