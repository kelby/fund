class CreateFundcompanyStars < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompany_stars do |t|
      t.integer :fundcompany_id
      t.string :name
      t.integer :funds_count
      t.integer :five_star_count
      t.integer :four_star_count
      t.integer :three_star_count
      t.integer :two_star_count
      t.integer :one_star_count
      t.integer :none_star_count

      t.timestamps
    end
    add_index :fundcompany_stars, :fundcompany_id
  end
end
