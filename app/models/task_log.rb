# == Schema Information
#
# Table name: task_logs
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  level      :string(255)
#  content    :text(65535)
#  ext_info   :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TaskLog < ApplicationRecord
  validates_presence_of :key
end
