class CreateQuickrankSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :quickrank_snapshots do |t|
      t.date :rating_date

      t.integer :project_id
      t.string :project_code
      t.string :morningstar_code
      t.string :project_name
      t.string :project_category

      t.integer :star_rating_five_year
      t.integer :star_rating_three_year

      t.date :record_at
      t.decimal :dwjz, precision: 15, scale: 4
      t.decimal :iopv, precision: 15, scale: 4

      t.decimal :yield_rate, precision: 15, scale: 4

      t.timestamps
    end

    add_index :quickrank_snapshots, :project_id
    add_index :quickrank_snapshots, :project_code
    add_index :quickrank_snapshots, :morningstar_code
    add_index :quickrank_snapshots, :rating_date
    add_index :quickrank_snapshots, [:project_code, :rating_date]
  end
end
