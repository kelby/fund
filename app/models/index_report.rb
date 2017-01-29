# == Schema Information
#
# Table name: index_reports
#
#  id             :integer          not null, primary key
#  catalog        :string(255)
#  category       :string(255)
#  category_intro :string(255)
#  name           :string(255)
#  intro          :text(65535)
#  website        :string(255)
#  code           :string(255)
#  set_up_at      :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class IndexReport < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :website
end
