class Project < ApplicationRecord
  belongs_to :category

  validates_presence_of :source_code
  validates_presence_of :category_id
end
