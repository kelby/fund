class AddCoverAndDescriptionToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :cover, :string
    add_column :catalogs, :description, :text
  end
end
