# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  catalog    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Stock < ApplicationRecord
  validates_presence_of :code, :name

  validates_uniqueness_of :code

  has_many :quotes
end
