class CreateFundJbgks < ActiveRecord::Migration[5.0]
  def change
    create_table :fund_jbgks do |t|
      t.string :full_name
      t.string :short_name
      t.string :code
      t.string :mold
      t.string :set_up_at
      t.string :build_at_and_scale
      t.string :assets_scale
      t.string :portion_scale

      t.string :benchmark
      t.text :dividend_policy
      t.string :risk_yield

      t.text :others

      t.timestamps
    end
  end
end
