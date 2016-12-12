# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text(16777215)
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates_presence_of :content, :commentable_id, :commentable_type, :user_id
end
