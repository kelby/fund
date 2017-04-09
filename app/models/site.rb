# == Schema Information
#
# Table name: sites
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  slug        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Site < ApplicationRecord
  validates_presence_of :title, :slug, :description
  validates_uniqueness_of :slug

  def to_param
    self.slug
  end
end
