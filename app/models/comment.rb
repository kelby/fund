# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text(65535)
#  commentable_id   :integer
#  commentable_type :string(191)
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :user_favor_comments


  validates_presence_of :content, :commentable_id, :commentable_type, :user_id

  before_create :set_floor

  acts_as_paranoid

  def set_floor
    last_floor = self.commentable.comments.with_deleted.size

    self.floor = last_floor + 1
  end

  def self.set_floor
    self.find_each do |comment|
      comments = comment.commentable.comments.with_deleted

      comments.each_with_index do |item, index|
        item.floor = index + 1

        if item.changed?
          item.save
        end
      end
    end
  end
end
