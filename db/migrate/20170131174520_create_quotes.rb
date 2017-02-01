class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      # 代码
      t.string :code
      # 名字
      t.string :name
      # 记录时间，以天为单位
      t.date :record_at
      # 上证、中证、泸深、香港、其它
      t.string :catalog
      # 现价/最新价
      t.decimal :price
      # 涨跌额
      t.decimal :up_down_number
      # 最高
      t.decimal :max_up_number
      # 最低
      t.decimal :min_down_number
      # 开盘
      t.decimal :open_number
      # 昨收
      t.decimal :yesterday_close_number
      # 涨跌幅
      t.decimal :up_down_rate
      # 最新行情时间
      t.datetime :last_updated_at

      # 成交额
      t.decimal :turnover
      # 成交量
      t.decimal :volume_of_business

      t.timestamps
    end
  end
end
