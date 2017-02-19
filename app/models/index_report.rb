# == Schema Information
#
# Table name: index_reports
#
#  id             :integer          not null, primary key
#  catalog        :string(255)
#  category       :string(255)
#  category_intro :string(255)
#  name           :string(255)
#  intro          :text(16777215)
#  website        :string(255)
#  code           :string(255)
#  set_up_at      :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string(255)
#

class IndexReport < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :website

  before_create :set_slug

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '')
  end

  def to_param
    "#{self.code}-#{self.slug}"
  end
end
