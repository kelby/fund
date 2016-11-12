class AddOthersToInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :pod_infos, :others, :text
    add_column :package_infos, :others, :text
    add_column :gem_infos, :others, :text
  end
end
