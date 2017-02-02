# == Schema Information
#
# Table name: project_items
#
#  id             :integer          not null, primary key
#  code           :string(255)
#  project_id     :integer
#  boolean_value  :boolean
#  string_value   :string(255)
#  integer_value  :integer
#  text_value     :text(65535)
#  datetime_value :datetime
#  date_value     :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ProjectItem < ApplicationRecord
  belongs_to :project

  validates_presence_of :project_id, :code

  validates_uniqueness_of :code, scope: :project_id
end
