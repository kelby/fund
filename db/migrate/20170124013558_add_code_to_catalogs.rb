class AddCodeToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :code, :string
  end
end
