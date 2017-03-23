# == Schema Information
#
# Table name: articles
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  description    :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  view_times     :integer          default(0)
#  comments_count :integer          default(0)
#  slug           :string(255)
#  can_reprinted  :boolean          default(TRUE)
#

class Article < ApplicationRecord
  validates_presence_of :title, :description


  # Associations
  belongs_to :user
  has_many :comments, as: :commentable
  # END


  # Callbacks
  before_create :set_slug
  # END


  def to_param
    "#{self.id}-#{self.slug}"
  end

  def set_slug
    self.slug = Pinyin.t(self.title, splitter: '-')
  end
end
