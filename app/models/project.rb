class Project < ApplicationRecord
  belongs_to :category

  has_one :github_info

  has_one :gem_info
  has_one :pod_info
  has_one :package_info

  validates_presence_of :source_code
  validates_presence_of :category_id
end
