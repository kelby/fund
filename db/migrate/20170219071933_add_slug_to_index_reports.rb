class AddSlugToIndexReports < ActiveRecord::Migration[5.0]
  def change
    add_column :index_reports, :slug, :string
  end
end
