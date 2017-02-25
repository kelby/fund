class AddFundChaiFensCountAndFundFenHongsCountToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :fund_chai_fens_count, :integer, default: 0, null: false
    add_column :projects, :fund_fen_hongs_count, :integer, default: 0, null: false

    Project.reset_column_information

    Project.find_each do |project|
      Project.reset_counters project.id, :fund_chai_fens_count
      Project.reset_counters project.id, :fund_fen_hongs_count
    end
  end
end
