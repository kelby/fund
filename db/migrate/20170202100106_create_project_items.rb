class CreateProjectItems < ActiveRecord::Migration[5.0]
  def change
    create_table :project_items do |t|
      t.string :code
      t.integer :project_id
      t.boolean :boolean_value
      t.string :string_value
      t.integer :integer_value
      t.text :text_value
      t.datetime :datetime_value
      t.date :date_value

      t.timestamps
    end

    add_index :project_items, [:project_id, :code]
  end
end
