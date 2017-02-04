class CreateFundChaiFens < ActiveRecord::Migration[5.0]
  def change
    create_table :fund_chai_fens do |t|
      t.date :break_convert_at
      t.string :break_type
      t.string :break_ratio

      t.integer :project_id
      t.integer :net_worth_id

      t.timestamps
    end
  end
end
