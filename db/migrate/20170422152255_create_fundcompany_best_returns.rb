class CreateFundcompanyBestReturns < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompany_best_returns do |t|
      t.integer :fundcompany_id
      t.string :name
      t.integer :return_inception_id
      t.decimal :return_inception
      t.integer :three_year_return_inception_id
      t.decimal :three_year_return_inception
      t.integer :this_year_return_inception_id
      t.decimal :this_year_return_inception

      t.timestamps
    end
    add_index :fundcompany_best_returns, :fundcompany_id
  end
end
