class CreateKinsfolks < ActiveRecord::Migration[5.0]
  def change
    create_table :kinsfolks do |t|
      t.integer :mother_id
      t.integer :son_id

      t.timestamps
    end

    add_index :kinsfolks, [:mother_id, :son_id]
  end
end
