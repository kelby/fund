# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  view_times  :integer          default(0)
#

class Article < ApplicationRecord
  validates_presence_of :title, :description


  belongs_to :user
  has_many :comments, as: :commentable
end
