class AddEastmoneyUrlToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :eastmoney_url, :string
  end
end
