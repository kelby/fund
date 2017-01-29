class CreateIndexReports < ActiveRecord::Migration[5.0]
  def change
    create_table :index_reports do |t|
      t.string :catalog
      t.string :category
      t.string :category_intro
      t.string :name
      t.text :intro
      t.string :website
      t.string :code
      t.date :set_up_at

      t.timestamps
    end
  end
end
