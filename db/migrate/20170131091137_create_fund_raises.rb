class CreateFundRaises < ActiveRecord::Migration[5.0]
  def change
    create_table :fund_raises do |t|
      t.integer :project_id
      t.date :beginning_at
      t.date :endding_at

      t.timestamps
    end
  end
end
