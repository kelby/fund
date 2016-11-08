class CreatePackageInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :package_infos do |t|
      t.integer :project_id
      t.decimal :total_downloads
      t.integer :releases
      t.string :current_version
      t.datetime :released
      t.datetime :first_release

      t.timestamps
    end
  end
end
