class ChangeCatalogSinaCodeToCatalogEastmoneyInfos < ActiveRecord::Migration[5.0]
  def change
    rename_column :catalog_eastmoney_infos, :catalog_sina_code, :catalog_code
  end
end
