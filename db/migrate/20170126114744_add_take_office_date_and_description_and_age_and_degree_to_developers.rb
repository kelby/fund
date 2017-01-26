class AddTakeOfficeDateAndDescriptionAndAgeAndDegreeToDevelopers < ActiveRecord::Migration[5.0]
  def change
    add_column :developers, :take_office_date, :date
    add_column :developers, :description, :text
    add_column :developers, :age, :integer, default: 0
    add_column :developers, :degree, :string
  end
end
