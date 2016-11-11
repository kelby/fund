class AddIdentityToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :identity, :integer, default: 0
  end
end
