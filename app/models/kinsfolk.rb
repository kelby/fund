# == Schema Information
#
# Table name: kinsfolks
#
#  id         :integer          not null, primary key
#  mother_id  :integer
#  son_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Kinsfolk < ApplicationRecord
  validates_presence_of :mother_id, :son_id
  validates_uniqueness_of :son_id, scope: :mother_id


  # 关系比较复杂时，先从简单的开始。所以，这是第一步
  belongs_to :mother_project, class_name: 'Project', foreign_key: :mother_id
  # 关系比较复杂时，先从简单的开始。所以，这是第一步
  belongs_to :son_project, class_name: 'Project', foreign_key: :son_id
end
