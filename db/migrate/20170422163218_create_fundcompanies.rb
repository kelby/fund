class CreateFundcompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompanies do |t|
      t.integer :project_id
      t.integer :morningstar_number
      t.string :morningstar_name

      t.timestamps
    end

    add_index :fundcompanies, :project_id
    add_index :fundcompanies, :morningstar_number
  end
end
