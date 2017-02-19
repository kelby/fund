class AddSlugToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :slug, :string
  end
end
