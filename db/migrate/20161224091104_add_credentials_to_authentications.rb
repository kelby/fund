class AddCredentialsToAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :credentials, :text
  end
end
