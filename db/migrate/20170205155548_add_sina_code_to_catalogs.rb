class AddSinaCodeToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :sina_code, :string

    add_index :catalogs, :sina_code
  end
end
