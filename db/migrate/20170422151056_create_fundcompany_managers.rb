class CreateFundcompanyManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompany_managers do |t|
      t.integer :fundcompany_id
      t.string :name
      t.integer :managers_count
      t.decimal :scale_manager_avg
      t.string :tenure_avg
      t.integer :three_years_tenure_count
      t.decimal :retention_rate

      t.timestamps
    end
    add_index :fundcompany_managers, :fundcompany_id
  end
end
