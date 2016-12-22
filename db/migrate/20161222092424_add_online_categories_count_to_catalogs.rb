class AddOnlineCategoriesCountToCatalogs < ActiveRecord::Migration[5.0]
  def change
    add_column :catalogs, :online_categories_count, :integer, nil: false, default: 0
  end
end
