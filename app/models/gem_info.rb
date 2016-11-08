class GemInfo < ApplicationRecord
  # from https://rubygems.org/

  belongs_to :project
end
