# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  tag_id        :integer
#  taggable_type :string(255)
#  taggable_id   :integer
#  tagger_type   :string(255)
#  tagger_id     :integer
#  context       :string(128)
#  created_at    :datetime
#

class CustomTagging < ::ActsAsTaggableOn::Tagging

end
