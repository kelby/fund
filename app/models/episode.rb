# == Schema Information
#
# Table name: episodes
#
#  id           :integer          not null, primary key
#  human_id     :integer
#  project_list :string(191)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :integer          default("offline")
#

class Episode < ApplicationRecord
  # Callbacks
  before_validation :set_human_id, on: :create
  before_create :set_human_id
  before_create :set_recommend_at
  # END


  # Validates
  validates_presence_of :human_id
  validates_presence_of :project_list
  # END


  # Rails class methods
  enum status: { offline: 0, online: 1 }
  # END

  def self.change_project_list_for(project_id, episode_id="")
    episode = self.get_episode(episode_id)

    episode.detect_and_change_project_list(project_id)
  end

  def self.get_episode(episode_id="")
    if episode_id.present?
      Episode.find(episode_id)
    else
      Episode.online.last
    end
  end

  def set_human_id
    self.human_id = Episode.count + 1
  end

  def set_recommend_at
    self.recommend_at = Time.now
  end

  def to_param
    "#{self.human_id}"
  end

  def detect_and_change_project_list(project_id="")
    self.concat_project_list(project_id)
    self.format_project_list

    if self.project_list_changed?
      self.save
    end
  end

  def concat_project_list(project_id="")
    self.project_list = self.project_list.concat(", #{project_id}")
  end

  def format_project_list
    self.project_list = self.project_list.split(",").uniq.join(",")
  end
end
