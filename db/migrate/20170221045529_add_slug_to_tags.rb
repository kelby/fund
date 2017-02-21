class AddSlugToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :slug, :string
    add_column :tags, :description, :text
  end
end
