# == Schema Information
#
# Table name: articles
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  description              :text(65535)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  user_id                  :integer
#  view_times               :integer          default(0)
#  comments_count           :integer          default(0)
#  slug                     :string(255)
#  can_reprinted            :boolean          default(TRUE)
#  agreement_articles_count :integer          default(0), not null
#  status                   :integer          default("online"), not null
#  article_category_id      :integer
#

class Article < ApplicationRecord
  include Searchable

  validates_presence_of :title, :description


  # Associations
  belongs_to :user
  has_many :comments, as: :commentable

  belongs_to :article_category
  # END


  # Callbacks
  before_create :set_slug
  # END

  enum status: { online: 0, offline: 11 }

  def to_param
    "#{self.id}-#{self.slug}"
  end

  def set_slug
    self.slug = Pinyin.t(self.title, splitter: '-')
  end

  mapping do
    indexes :id, type: :integer

    indexes :title
  end

  def as_indexed_json(options={})
    self.as_json(only: [:id, :title])
  end
end
