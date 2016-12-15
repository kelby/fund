class CreateEpisodes < ActiveRecord::Migration[5.0]
  def change
    create_table :episodes do |t|
      t.integer :human_id
      t.string :project_list

      t.timestamps
    end
  end
end
