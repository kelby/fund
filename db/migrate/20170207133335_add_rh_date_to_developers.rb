class AddRhDateToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :rh_at, :date
  end
end
