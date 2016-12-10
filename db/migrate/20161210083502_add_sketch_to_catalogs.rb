class AddSketchToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :sketch, :string
  end
end
