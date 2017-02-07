class AddEastmoneyCodeAndSinaCodeToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :eastmoney_code, :string
    add_column :developers, :sina_code, :string

    add_index :developers, :eastmoney_code
    add_index :developers, :sina_code
  end
end
