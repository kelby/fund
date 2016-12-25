class AddFloorToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :floor, :integer
  end
end
