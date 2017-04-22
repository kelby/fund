class CreateFundcompanyInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :fundcompany_infos do |t|
      t.integer :fundcompany_id
      t.string :name
      t.string :city
      t.string :address
      t.string :zip_code
      t.string :telphone
      t.string :website

      t.timestamps
    end
    add_index :fundcompany_infos, :fundcompany_id
  end
end
