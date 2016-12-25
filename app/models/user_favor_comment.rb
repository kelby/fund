class UserFavorComment < ApplicationRecord
  validates_presence_of :user_id, :comment_id
  validates_uniqueness_of :user_id, scope: :comment_id

  belongs_to :user
  belongs_to :comment

  def self.had_faver_by?(comment, user)
    return false if user.blank?

    self.where(comment_id: comment.id, user_id: user.id).present?
  end
end
