class AddRefreshTokenToAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :refresh_token, :string
  end
end
