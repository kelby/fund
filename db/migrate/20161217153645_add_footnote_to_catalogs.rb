class AddFootnoteToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :footnote, :text
  end
end
