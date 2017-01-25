class CreateNetWorths < ActiveRecord::Migration[5.0]
  def change
    create_table :net_worths do |t|
      t.decimal :iopv, precision: 15, scale: 4
      t.decimal :dwjz, precision: 15, scale: 4
      t.decimal :accnav, precision: 15, scale: 4
      t.decimal :ljjz, precision: 15, scale: 4

      t.timestamps
    end
  end
end
