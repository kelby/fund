class CreateFundcompanyPerformances < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompany_performances do |t|
      t.integer :fundcompany_id
      t.string :name
      t.integer :rank_pre_one_four
      t.integer :rank_pre_one_two
      t.integer :rank_post_one_four
      t.integer :rank_post_one_two
      t.integer :return_lt_zero
      t.integer :return_zero_to_ten
      t.integer :return_ten_to_twenty
      t.integer :return_twenty_to_thirty
      t.integer :return_thirty_to_fifty
      t.integer :return_gt_fifty

      t.timestamps
    end
    add_index :fundcompany_performances, :fundcompany_id
  end
end
