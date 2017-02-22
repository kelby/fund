# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  taggings_count :integer          default(0)
#  slug           :string(255)
#  description    :text(65535)
#

class CustomTag < ::ActsAsTaggableOn::Tag
  before_create :set_slug

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: "")
  end

  def to_param
    self.slug.presence || "#{self.id}"
  end
end
