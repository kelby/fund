# == Schema Information
#
# Table name: quotes
#
#  id                     :integer          not null, primary key
#  code                   :string(255)
#  name                   :string(255)
#  record_at              :date
#  catalog                :string(255)
#  price                  :decimal(10, )
#  up_down_number         :decimal(10, )
#  max_up_number          :decimal(10, )
#  min_down_number        :decimal(10, )
#  open_number            :decimal(10, )
#  yesterday_close_number :decimal(10, )
#  up_down_rate           :decimal(10, )
#  last_updated_at        :datetime
#  turnover               :decimal(10, )
#  volume_of_business     :decimal(10, )
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stock_id               :integer
#

class Quote < ApplicationRecord
  validates_presence_of :code, :name

  validates_uniqueness_of :code


  belongs_to :stock
end
