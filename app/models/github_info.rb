class GithubInfo < ApplicationRecord
  # from https://developer.github.com/v3/

  belongs_to :project, autosave: true
end
