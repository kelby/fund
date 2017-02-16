class AddStatusToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :status, :integer, default: 0

    Developer.reset_column_information

    Developer.where(name: [nil, ""]).update_all(status: 1)
  end
end
